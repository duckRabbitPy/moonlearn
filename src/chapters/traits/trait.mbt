pub(open) trait Position {
  pos(self: Self) -> (Int, Int)
}

pub(open) trait Draw {
  draw(self : Self, x : Int, y : Int) -> Unit
}

pub(open) trait Object: Position + Draw {
  
}

pub(all) struct Circle {
  radius : Int
}

pub(all) struct Square {
  side: Int
}

pub(all) struct Triangle {
  base: Int
  height: Int
}

pub impl Position for Circle with pos(self) {
  (self.radius * 2, self.radius * 2)
}

pub impl Draw for Circle with draw(self, x, y) {
  println("Drawing circle with radius \{self.radius} at position (\{x}, \{y})")
}

pub impl Position for Square with pos(self) {
  (self.side, self.side)
}

pub impl Draw for Square with draw(self, x, y) {
  println("Drawing square with side \{self.side} at position (\{x}, \{y})")
}

pub impl Position for Triangle with pos(self) {
  (self.base, self.height)
}

pub impl Draw for Triangle with draw(self, x, y) {
  println("Drawing triangle with base \{self.base} and height \{self.height} at position (\{x}, \{y})")
}

pub fn test_shapes() -> Unit {

}
