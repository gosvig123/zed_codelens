// Sample JavaScript file to test the CodeLens extension
// Expected reference counts are shown in comments

// Expected: 2 references
function calculateArea(width, height) {
    return width * height;
}

// Expected: 3 references
class Rectangle {
    constructor(width, height) {
        this.width = width;
        this.height = height;
    }

    area() {
        return calculateArea(this.width, this.height);  // Reference 1 to calculateArea
    }

    perimeter() {
        return 2 * (this.width + this.height);
    }
}

// Expected: 2 references
const Shape = {
    CIRCLE: 'circle',
    RECTANGLE: 'rectangle',
    TRIANGLE: 'triangle'
};

// Expected: 1 reference
const PI = 3.14159;

// Expected: 1 reference
let globalCounter = 0;

function main() {
    const rect = new Rectangle(10, 5);  // Reference 1 to Rectangle
    const area = rect.area();
    const perimeter = rect.perimeter();
    
    console.log(`Rectangle area: ${area}`);
    console.log(`Rectangle perimeter: ${perimeter}`);
    
    const shape = Shape.CIRCLE;  // Reference 1 to Shape
    const rectShape = Shape.RECTANGLE;  // Reference 2 to Shape
    
    const manualArea = calculateArea(8, 6);  // Reference 2 to calculateArea
    console.log(`Manual area calculation: ${manualArea}`);
    
    console.log(`PI value: ${PI}`);  // Reference 1 to PI
    globalCounter++;  // Reference 1 to globalCounter
}

// Expected: 0 references
function unusedFunction() {
    console.log("This function is never called");
}

// Arrow function - Expected: 1 reference
const multiply = (a, b) => a * b;

// Expected: 1 reference
const divide = function(a, b) {
    return a / b;
};

function useUtilityFunctions() {
    const result = multiply(4, 5);  // Reference 1 to multiply
    const quotient = divide(10, 2);  // Reference 1 to divide
    console.log(`Multiply result: ${result}, Divide result: ${quotient}`);
}

// Export for cross-file testing
export { Rectangle, calculateArea, Shape };
export default PI;
