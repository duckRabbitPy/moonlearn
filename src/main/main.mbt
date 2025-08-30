

fn main {
  // unit
  println(@lib.hello())
  println(@utils.add(1, 2))
  
  @boolean.print_boolean()
  @unit.print_hello_unit()
  @boolean.print_boolean()
  println(@option.some_or_default(Some(42), 0))
  println(@number.addAny(1, 2))
  println(@tuple.sum_tuple(1, 2, c=3))
  println(@ref.new(1))
  println(@string.greeting("John"))
}



