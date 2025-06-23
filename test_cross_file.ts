// Cross-file test for TypeScript CodeLens extension
// This file imports symbols from test_sample.ts to test cross-file references

import { Rectangle, calculateArea, Shape, Point, ShapeType } from './test_sample';
import type { Drawable, Container } from './test_sample';
import PI from './test_sample';

// This should increase the reference count for imported symbols

// Using imported types
class Circle implements Shape, Drawable {  // Cross-file references to Shape and Drawable
    constructor(private radius: number) {}
    
    area(): number {
        return PI * this.radius * this.radius;  // Cross-file reference to PI
    }
    
    perimeter(): number {
        return 2 * PI * this.radius;  // Another cross-file reference to PI
    }
    
    draw(): void {
        console.log(`Drawing circle with radius: ${this.radius}`);
    }
}

function testCrossFileReferences(): void {
    // Using Rectangle from test_sample.ts
    const rect: Rectangle = new Rectangle(15, 10);  // Cross-file reference to Rectangle
    console.log(`Cross-file rectangle area: ${rect.area()}`);
    
    // Using calculateArea from test_sample.ts
    const area: number = calculateArea(20, 8);  // Cross-file reference to calculateArea
    console.log(`Cross-file area calculation: ${area}`);
    
    // Using Point from test_sample.ts
    const point: Point = { x: 25, y: 30 };  // Cross-file reference to Point
    console.log(`Cross-file point: (${point.x}, ${point.y})`);
    
    // Using ShapeType from test_sample.ts
    const shapeType: ShapeType = ShapeType.CIRCLE;  // Cross-file reference to ShapeType
    console.log(`Cross-file shape type: ${shapeType}`);
    
    // Using Container type from test_sample.ts
    const numberContainer: Container<number> = {  // Cross-file reference to Container
        value: 42,
        getValue() { return this.value; }
    };
    console.log(`Cross-file container value: ${numberContainer.getValue()}`);
    
    // Creating a Circle instance
    const circle = new Circle(5);
    console.log(`Circle area: ${circle.area()}`);
    console.log(`Circle perimeter: ${circle.perimeter()}`);
    circle.draw();
}

// Local function that should show 1 reference
function localFunction(): string {
    return "This is a local function";
}

// Generic function using imported types
function createPoint<T extends number>(x: T, y: T): Point {  // Cross-file reference to Point
    return { x, y };
}

function main(): void {
    testCrossFileReferences();
    console.log(localFunction());  // Reference to localFunction
    
    const newPoint = createPoint(100, 200);  // Reference to createPoint
    console.log(`Created point: (${newPoint.x}, ${newPoint.y})`);
}

// Export for potential further cross-file testing
export { testCrossFileReferences, Circle, createPoint };
