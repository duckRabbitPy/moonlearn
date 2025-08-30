test "result_is_ok" {
  let result = Ok(42)
  assert_eq(result_is_ok(result), true)
}

test "result_is_ok2" {
  let result = Ok(42)
  assert_eq(result_is_ok2(result), true)
}


test "result_is_err" {
  let result = Err("Error")
  assert_eq(result_is_err(result), true)
}

test "result_unwrap" {
  let result = Ok(42)
  assert_eq(result_unwrap(result), 42)
}

test "result_unwrap_or_else" {
  let result = Ok(42)
  assert_eq(result_or_else(result, 0), 42)
}

test "result_map" {
  let result = Ok(42)
  assert_eq(result_map(result, (x) => x + 1), Ok(43))
}

test "result_map_err" {
  let result = Err("Error")
  assert_eq(result_map_err(result, (x) => x + "!"), Err("Error!"))
}