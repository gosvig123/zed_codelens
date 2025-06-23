// Sample TypeScript file to test the CodeLens extension
// Expected reference counts are shown in comments

// Expected: 2 references
interface Drawable {
    draw(): void;
}

// Expected: 3 references
interface Shape {
    area(): number;
    perimeter(): number;
}

// Expected: 2 references
type Point = {
    x: number;
    y: number;
};

// Expected: 3 references
class Rectangle implements Shape, Drawable {
    constructor(private width: number, private height: number) {}

    area(): number {
        return calculateArea(this.width, this.height);  // Reference 1 to calculateArea
    }

    perimeter(): number {
        return 2 * (this.width + this.height);
    }

    draw(): void {
        console.log(`Drawing rectangle: ${this.width}x${this.height}`);
    }
}

// Expected: 2 references
function calculateArea(width: number, height: number): number {
    return width * height;
}

// Expected: 2 references
enum ShapeType {
    CIRCLE = 'circle',
    RECTANGLE = 'rectangle',
    TRIANGLE = 'triangle'
}

// Expected: 1 reference
const PI: number = 3.14159;

// Expected: 1 reference
let globalCounter: number = 0;

// Generic function - Expected: 1 reference
function identity<T>(arg: T): T {
    return arg;
}

// Type alias with generics - Expected: 1 reference
type Container<T> = {
    value: T;
    getValue(): T;
};

function main(): void {
    const rect: Rectangle = new Rectangle(10, 5);  // Reference 1 to Rectangle
    const area: number = rect.area();
    const perimeter: number = rect.perimeter();
    
    console.log(`Rectangle area: ${area}`);
    console.log(`Rectangle perimeter: ${perimeter}`);
    
    const shape: ShapeType = ShapeType.CIRCLE;  // Reference 1 to ShapeType
    const rectShape: ShapeType = ShapeType.RECTANGLE;  // Reference 2 to ShapeType
    
    const manualArea: number = calculateArea(8, 6);  // Reference 2 to calculateArea
    console.log(`Manual area calculation: ${manualArea}`);
    
    console.log(`PI value: ${PI}`);  // Reference 1 to PI
    globalCounter++;  // Reference 1 to globalCounter
    
    const point: Point = { x: 10, y: 20 };  // Reference 1 to Point
    const anotherPoint: Point = { x: 5, y: 15 };  // Reference 2 to Point
    
    const stringContainer: Container<string> = {  // Reference 1 to Container
        value: "hello",
        getValue() { return this.value; }
    };
    
    const identityResult = identity<number>(42);  // Reference 1 to identity
}

// Expected: 0 references
function unusedFunction(): void {
    console.log("This function is never called");
}

// Arrow function with types - Expected: 1 reference
const multiply = (a: number, b: number): number => a * b;

// Expected: 1 reference
const divide: (a: number, b: number) => number = function(a, b) {
    return a / b;
};

function useUtilityFunctions(): void {
    const result: number = multiply(4, 5);  // Reference 1 to multiply
    const quotient: number = divide(10, 2);  // Reference 1 to divide
    console.log(`Multiply result: ${result}, Divide result: ${quotient}`);
}

// Abstract class - Expected: 1 reference
abstract class Animal {
    abstract makeSound(): void;
}

// Expected: 1 reference
class Dog extends Animal {  // Reference 1 to Animal
    makeSound(): void {
        console.log("Woof!");
    }
}

function createDog(): Dog {  // Reference 1 to Dog
    return new Dog();
}

// Export for cross-file testing
export { Rectangle, calculateArea, Shape, Point, ShapeType };
export type { Drawable, Container };
export default PI;
