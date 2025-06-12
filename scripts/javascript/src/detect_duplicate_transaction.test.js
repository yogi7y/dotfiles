const {
  findDuplicateTransactions,
  arePotentialDuplicates,
  normalizeAmount,
  isWithinTimeWindow,
  DUPLICATE_DETECTION_CONFIG,
} = require("./detect_duplicate_transaction");

describe("normalizeAmount", () => {
  test("should remove decimal places", () => {
    expect(normalizeAmount(100.99)).toBe(100);
    expect(normalizeAmount(100.01)).toBe(100);
    expect(normalizeAmount(100.0)).toBe(100);
  });

  test("should handle whole numbers", () => {
    expect(normalizeAmount(100)).toBe(100);
    expect(normalizeAmount(0)).toBe(0);
  });
});

describe("isWithinTimeWindow", () => {
  test("should return true for transactions within time window", () => {
    const date1 = new Date("2024-03-15T10:00:00");
    const date2 = new Date("2024-03-15T10:44:59"); // 44:59 minutes apart
    expect(isWithinTimeWindow(date1, date2)).toBe(true);
  });

  test("should return false for transactions outside time window", () => {
    const date1 = new Date("2024-03-15T10:00:00");
    const date2 = new Date("2024-03-15T10:45:01"); // 45:01 minutes apart
    expect(isWithinTimeWindow(date1, date2)).toBe(false);
  });

  test("should handle reversed order of dates", () => {
    const date1 = new Date("2024-03-15T10:45:00");
    const date2 = new Date("2024-03-15T10:00:00");
    expect(isWithinTimeWindow(date1, date2)).toBe(true);
  });
});

describe("arePotentialDuplicates", () => {
  const baseTransaction = {
    amount: 1000.99,
    type: "debit",
    datetime: new Date("2024-03-15T10:00:00"),
    description: "Test transaction",
    merchant: "Test Merchant",
  };

  test("should identify duplicate transactions", () => {
    const transaction1 = { ...baseTransaction };
    const transaction2 = {
      ...baseTransaction,
      datetime: new Date("2024-03-15T10:30:00"), // 30 minutes later
      description: "Different description", // Should still match as we don't compare description
      merchant: "Different Merchant", // Should still match as we don't compare merchant
    };
    expect(arePotentialDuplicates(transaction1, transaction2)).toBe(true);
  });

  test("should not identify same transaction object as duplicate", () => {
    expect(arePotentialDuplicates(baseTransaction, baseTransaction)).toBe(
      false
    );
  });

  test("should not match transactions with different amounts", () => {
    const transaction2 = {
      ...baseTransaction,
      amount: 1001.99,
    };
    expect(arePotentialDuplicates(baseTransaction, transaction2)).toBe(false);
  });

  test("should not match transactions with different types", () => {
    const transaction2 = {
      ...baseTransaction,
      type: "credit",
    };
    expect(arePotentialDuplicates(baseTransaction, transaction2)).toBe(false);
  });

  test("should not match transactions outside time window", () => {
    const transaction2 = {
      ...baseTransaction,
      datetime: new Date("2024-03-15T11:00:00"), // 1 hour later
    };
    expect(arePotentialDuplicates(baseTransaction, transaction2)).toBe(false);
  });
});

describe("findDuplicateTransactions", () => {
  test("should handle empty array", () => {
    expect(findDuplicateTransactions([])).toEqual([]);
  });

  test("should handle null or undefined input", () => {
    expect(findDuplicateTransactions(null)).toEqual([]);
    expect(findDuplicateTransactions(undefined)).toEqual([]);
  });

  test("should handle single transaction", () => {
    const transactions = [
      {
        amount: 1000,
        type: "debit",
        datetime: new Date("2024-03-15T10:00:00"),
        description: "Test",
        merchant: "Test",
      },
    ];
    expect(findDuplicateTransactions(transactions)).toEqual([]);
  });

  test("should identify duplicate transactions", () => {
    const transactions = [
      {
        amount: 1000.99,
        type: "debit",
        datetime: new Date("2024-03-15T10:00:00"),
        description: "Amazon order",
        merchant: "AMAZON",
      },
      {
        amount: 1000.45, // Same floor amount
        type: "debit",
        datetime: new Date("2024-03-15T10:15:00"),
        description: "Purchase at Amazon",
        merchant: "AMZN",
      },
      {
        amount: 500.0,
        type: "debit",
        datetime: new Date("2024-03-15T10:00:00"),
        description: "Different transaction",
        merchant: "Other",
      },
    ];

    const result = findDuplicateTransactions(transactions);
    expect(result.length).toBe(1); // One group of duplicates
    expect(result[0].length).toBe(2); // Two transactions in the group
    expect(result[0].map((t) => Math.floor(t.amount))).toEqual([1000, 1000]);
  });

  test("should handle multiple groups of duplicates", () => {
    const transactions = [
      // Group 1
      {
        amount: 1000.99,
        type: "debit",
        datetime: new Date("2024-03-15T10:00:00"),
        description: "First transaction",
        merchant: "Merchant A",
      },
      {
        amount: 1000.45,
        type: "debit",
        datetime: new Date("2024-03-15T10:15:00"),
        description: "Second transaction",
        merchant: "Merchant B",
      },
      // Group 2
      {
        amount: 500.99,
        type: "credit",
        datetime: new Date("2024-03-15T11:00:00"),
        description: "Third transaction",
        merchant: "Merchant C",
      },
      {
        amount: 500.45,
        type: "credit",
        datetime: new Date("2024-03-15T11:15:00"),
        description: "Fourth transaction",
        merchant: "Merchant D",
      },
      // Non-duplicate transaction
      {
        amount: 750.0,
        type: "debit",
        datetime: new Date("2024-03-15T12:00:00"),
        description: "Unique transaction",
        merchant: "Merchant E",
      },
    ];

    const result = findDuplicateTransactions(transactions);
    expect(result.length).toBe(2); // Two groups of duplicates
    expect(result[0].length).toBe(2); // Two transactions in first group
    expect(result[1].length).toBe(2); // Two transactions in second group

    // Verify amounts in each group
    expect(result[0].map((t) => Math.floor(t.amount))).toEqual([1000, 1000]);
    expect(result[1].map((t) => Math.floor(t.amount))).toEqual([500, 500]);
  });

  test("should not group transactions with same amount but different types", () => {
    const transactions = [
      {
        amount: 1000.0,
        type: "debit",
        datetime: new Date("2024-03-15T10:00:00"),
        description: "Payment",
        merchant: "Merchant",
      },
      {
        amount: 1000.0,
        type: "credit",
        datetime: new Date("2024-03-15T10:15:00"),
        description: "Refund",
        merchant: "Merchant",
      },
    ];

    const result = findDuplicateTransactions(transactions);
    expect(result).toEqual([]);
  });
});
