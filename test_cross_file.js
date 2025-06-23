// Cross-file test for JavaScript CodeLens extension
// This file imports symbols from test_sample.js to test cross-file references

import { Rectangle, calculateArea, Shape } from './test_sample.js';
import PI from './test_sample.js';

// This should increase the reference count for Rectangle, calculateArea, Shape, and PI

function testCrossFileReferences() {
    // Using Rectangle from test_sample.js
    const rect = new Rectangle(15, 10);  // Cross-file reference to Rectangle
    console.log(`Cross-file rectangle area: ${rect.area()}`);
    
    // Using calculateArea from test_sample.js
    const area = calculateArea(20, 8);  // Cross-file reference to calculateArea
    console.log(`Cross-file area calculation: ${area}`);
    
    // Using Shape from test_sample.js
    const shapeType = Shape.TRIANGLE;  // Cross-file reference to Shape
    console.log(`Cross-file shape type: ${shapeType}`);
    
    // Using PI from test_sample.js
    const circumference = 2 * PI * 5;  // Cross-file reference to PI
    console.log(`Cross-file circumference: ${circumference}`);
}

// Local function that should show 1 reference
function localFunction() {
    return "This is a local function";
}

function main() {
    testCrossFileReferences();
    console.log(localFunction());  // Reference to localFunction
}

// Export for potential further cross-file testing
export { testCrossFileReferences };
