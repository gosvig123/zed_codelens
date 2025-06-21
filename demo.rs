// Demo file for CodeLens References Extension
// This file demonstrates the extension's capability to show reference counts

// This function should show "3 references"
fn add_numbers(a: i32, b: i32) -> i32 {
    a + b
}

// This struct should show "2 references"
struct Calculator {
    name: String,
}

// This implementation should show "1 reference"
impl Calculator {
    fn new(name: String) -> Self {
        Calculator { name }
    }
    
    fn calculate(&self, x: i32, y: i32) -> i32 {
        add_numbers(x, y)  // Reference 1 to add_numbers
    }
}

// This enum should show "1 reference"
enum Operation {
    Add,
    Subtract,
    Multiply,
}

// This trait should show "1 reference"
trait Compute {
    fn compute(&self, op: Operation) -> i32;
}

// This implementation should show "0 references"
impl Compute for Calculator {  // Reference 1 to Calculator
    fn compute(&self, op: Operation) -> i32 {  // Reference 1 to Operation
        match op {
            Operation::Add => 42,
            Operation::Subtract => 0,
            Operation::Multiply => 1,
        }
    }
}

fn main() {
    let calc = Calculator::new("Demo Calculator".to_string());  // Reference 2 to Calculator
    
    let result1 = calc.calculate(10, 20);  // Uses add_numbers internally
    let result2 = add_numbers(5, 15);      // Reference 2 to add_numbers
    let result3 = add_numbers(1, 2);       // Reference 3 to add_numbers
    
    println!("Results: {}, {}, {}", result1, result2, result3);
}

// This function should show "0 references"
fn unused_function() {
    println!("This function is never called");
}

// This constant should show "1 reference"
const MAX_VALUE: i32 = 100;

fn use_constant() {
    println!("Max value: {}", MAX_VALUE);  // Reference 1 to MAX_VALUE
}
