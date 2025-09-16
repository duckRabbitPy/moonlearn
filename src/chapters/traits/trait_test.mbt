test "test_shapes" {
  @traits.test_shapes()

  let circle = @traits.Circle::{ radius: 3 }
  let square = @traits.Square::{ side: 4 }
  let triangle = @traits.Triangle::{ base: 5, height: 6 }
  
  // & allows polymorphic array
  let shapes: Array[&Object] = [circle, square, triangle]

  assert_eq(shapes.length(), 3)
  assert_eq(shapes[0].pos(), (6, 6))
  assert_eq(shapes[1].pos(), (4, 4))
  assert_eq(shapes[2].pos(), (5, 6))
  
  for shape in shapes {
    let (x, y) = shape.pos()
    shape.draw(x, y)
  }
}