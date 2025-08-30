pub fn result_is_ok(result: Result[Int, String]) -> Bool {
  return result.is_ok()
}

pub fn result_is_ok2(result: Result[Int, String]) -> Bool {
  return match result {
    Ok(_) => true
    Err(_) => false
  }
}

pub fn result_is_err(result: Result[Int, String]) -> Bool {
  return result.is_err()
}


pub fn result_unwrap(result: Result[Int, String]) -> Int {
  // will panic if result is Err
  return result.unwrap()
}

pub fn result_or_else(result: Result[Int, String], default: Int) -> Int {
  return result.or_else(() =>default)
}

pub fn result_map(res: Result[Int, String], f: (Int) -> Int) -> Result[Int, String] {
  return res.map(f)
}

pub fn result_map_err(res: Result[Int, String], f: (String) -> String) -> Result[Int, String] {
  return res.map_err(f)
}


