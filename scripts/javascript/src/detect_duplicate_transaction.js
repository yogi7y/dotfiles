/**
 * Constants for duplicate detection configuration
 */
const DUPLICATE_DETECTION_CONFIG = {
  // Time window in milliseconds (45 minutes)
  TIME_WINDOW_MS: 45 * 60 * 1000,
};

/**
 * @typedef {Object} Transaction
 * @property {number} amount - Transaction amount in INR
 * @property {string} type - Transaction type ('credit' or 'debit')
 * @property {Date} datetime - Transaction timestamp
 * @property {string} description - Transaction description
 * @property {string} merchant - Merchant name (not used in duplicate detection currently)
 */

/**
 * Normalizes the transaction amount by removing decimal places
 * @param {number} amount - Transaction amount
 * @returns {number} - Normalized amount
 */
function normalizeAmount(amount) {
  return Math.floor(amount);
}

/**
 * Checks if two transactions occurred within the configured time window
 * @param {Date} datetime1 - Timestamp of first transaction
 * @param {Date} datetime2 - Timestamp of second transaction
 * @returns {boolean} - True if transactions are within time window
 */
function isWithinTimeWindow(datetime1, datetime2) {
  const timeDifference = Math.abs(datetime1.getTime() - datetime2.getTime());
  return timeDifference <= DUPLICATE_DETECTION_CONFIG.TIME_WINDOW_MS;
}

/**
 * Checks if two transactions are potential duplicates
 * @param {Transaction} transaction1 - First transaction
 * @param {Transaction} transaction2 - Second transaction
 * @returns {boolean} - True if transactions are potential duplicates
 */
function arePotentialDuplicates(transaction1, transaction2) {
  // If it's the same transaction object, return false
  if (transaction1 === transaction2) return false;

  return (
    // Compare normalized amounts
    normalizeAmount(transaction1.amount) ===
      normalizeAmount(transaction2.amount) &&
    // Compare transaction types
    transaction1.type === transaction2.type &&
    // Check if within time window
    isWithinTimeWindow(transaction1.datetime, transaction2.datetime)
  );
}

/**
 * Finds duplicate transactions in a list of transactions
 * @param {Transaction[]} transactions - Array of transactions to check for duplicates
 * @returns {Transaction[][]} - Array of duplicate transaction groups
 */
function findDuplicateTransactions(transactions) {
  if (!Array.isArray(transactions) || transactions.length === 0) {
    return [];
  }

  // Sort transactions by amount and then by datetime for efficient processing
  const sortedTransactions = [...transactions].sort((a, b) => {
    const amountDiff = normalizeAmount(a.amount) - normalizeAmount(b.amount);
    if (amountDiff === 0) {
      return a.datetime.getTime() - b.datetime.getTime();
    }
    return amountDiff;
  });

  const duplicateGroups = [];
  let currentGroup = [];

  for (let i = 0; i < sortedTransactions.length; i++) {
    const currentTransaction = sortedTransactions[i];

    // If this is the first transaction or it's not a duplicate of the previous one
    if (currentGroup.length === 0) {
      currentGroup.push(currentTransaction);
      continue;
    }

    // Check if current transaction is a duplicate of the last transaction in current group
    const lastTransaction = currentGroup[currentGroup.length - 1];

    if (arePotentialDuplicates(currentTransaction, lastTransaction)) {
      currentGroup.push(currentTransaction);
    } else {
      // If we found duplicates, add the group to our results
      if (currentGroup.length > 1) {
        duplicateGroups.push([...currentGroup]);
      }
      // Start a new group with the current transaction
      currentGroup = [currentTransaction];
    }
  }

  // Don't forget to add the last group if it contains duplicates
  if (currentGroup.length > 1) {
    duplicateGroups.push(currentGroup);
  }

  return duplicateGroups;
}

module.exports = {
  findDuplicateTransactions,
  arePotentialDuplicates,
  normalizeAmount,
  isWithinTimeWindow,
  DUPLICATE_DETECTION_CONFIG,
};
