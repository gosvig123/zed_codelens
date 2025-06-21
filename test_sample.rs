// Sample Rust file to test the CodeLens extension

// This function should show "2 references"
fn calculate_area(width: f64, height: f64) -> f64 {
    width * height
}

// This struct should show "3 references"
struct Rectangle {
    width: f64,
    height: f64,
}

// This implementation should show "1 reference"
impl Rectangle {
    fn new(width: f64, height: f64) -> Self {
        Rectangle { width, height }
    }
    
    fn area(&self) -> f64 {
        calculate_area(self.width, self.height)  // Reference 1 to calculate_area
    }
    
    fn perimeter(&self) -> f64 {
        2.0 * (self.width + self.height)
    }
}

// This enum should show "2 references"
enum Shape {
    Circle(f64),
    Rectangle(Rectangle),  // Reference 1 to Rectangle
    Triangle(f64, f64, f64),
}

// This trait should show "1 reference"
trait Drawable {
    fn draw(&self);
}

// This implementation should show "0 references"
impl Drawable for Rectangle {  // Reference 2 to Rectangle
    fn draw(&self) {
        println!("Drawing rectangle: {}x{}", self.width, self.height);
    }
}

fn main() {
    let rect = Rectangle::new(10.0, 5.0);  // Reference 3 to Rectangle
    let area = rect.area();
    let perimeter = rect.perimeter();
    
    println!("Rectangle area: {}", area);
    println!("Rectangle perimeter: {}", perimeter);
    
    let shape = Shape::Circle(5.0);  // Reference 1 to Shape
    let rect_shape = Shape::Rectangle(rect);  // Reference 2 to Shape
    
    let manual_area = calculate_area(8.0, 6.0);  // Reference 2 to calculate_area
    println!("Manual area calculation: {}", manual_area);
}

// This function should show "0 references"
fn unused_function() {
    println!("This function is never called");
}

// This constant should show "1 reference"
const PI: f64 = 3.14159;

// This static should show "1 reference"
static GLOBAL_COUNTER: std::sync::atomic::AtomicUsize = std::sync::atomic::AtomicUsize::new(0);

fn use_constants() {
    println!("PI value: {}", PI);  // Reference 1 to PI
    GLOBAL_COUNTER.fetch_add(1, std::sync::atomic::Ordering::SeqCst);  // Reference 1 to GLOBAL_COUNTER
}
