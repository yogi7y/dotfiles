const { convert } = require("html-to-text");

const options = {
  selectors: [
    { selector: "img", format: "skip" },
    { selector: "a", options: { ignoreHref: true } },
  ],
};

const html1 = `<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sample 1 - Basic</title>
</head>
<body>
    <h1>Welcome to My Website</h1>
    <p>This is a simple paragraph to test basic HTML to plain text conversion.</p>
    <p>Here is a <a href="https://example.com">link</a> for testing.</p>
</body>
</html>
`;

console.log(convert(html1, options));

console.log("--------------------------------");

const html2 = `
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sample 2 - Nested Elements</title>
</head>
<body>
    <h2>Features</h2>
    <ul>
        <li>Easy to use</li>
        <li>Fast processing
            <ul>
                <li>Optimized algorithms</li>
                <li>Low latency</li>
            </ul>
        </li>
        <li>Cross-platform</li>
    </ul>
    <p>End of list.</p>
</body>
</html>
`;

console.log(convert(html2, options));
