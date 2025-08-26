pub fn swap_ref(r1: Ref[String], r2: Ref[String]) -> (Ref[String], Ref[String]) {
  @ref.swap(r1, r2)

  return (r1, r2)
}

pub fn swap_ref_with_new() -> (Ref[String], Ref[String]) {
  let r1 = @ref.new("first")
  let r2 = @ref.new("second")
  @ref.swap(r1, r2)
  return (r1, r2)
}


pub fn [T]new (value: T) -> Ref[T] {
  @ref.new(value)
}

pub fn map_numerical_ref(num: Ref[Int], afunction: (Int) -> Int) -> Ref[Int] {
  return num.map(afunction)
}