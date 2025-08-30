
pub fn some_or_default(some : Int?, default : Int) -> Int {
  return match some {
      Some(value) => value
      None => default
    }
  }

pub fn some_or_default2(some : Int?, default : Int) -> Int {
  return some.unwrap_or(default)
}

pub fn some_or_abort(some : Int?) -> Int {
  return match some {
    Some(value) => value
    None => abort("No value")
  }
}

pub fn filter_some(someArray : Array[Int?]) -> Array[Int] {

  let valueElseZero = (value: Int?) => {
    return match value {
      Some(value) => value
      None => 0
    }
  }

  return someArray.map(valueElseZero)
}

pub fn flatten_double_nested_option(nestedSome: Option[Option[Option[Int]]]) -> Option[Int] {
  return nestedSome.flatten().flatten()
}
