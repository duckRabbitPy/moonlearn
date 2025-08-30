test "some_or_default" {
  let some = Some(1)
  let none = None

  assert_eq(some_or_default(some, 0), 1)
  assert_eq(some_or_default(none, 0), 0)
}

test "filter_some" { 

  let someArray = [Some(1), Some(2), Some(3), None, Some(4), None, Some(5)  ]

  let filtered = filter_some(someArray)

  assert_eq(filtered, [1, 2, 3, 0, 4, 0, 5])
}

test "flatten_double_nested_option" {
  let nestedSome = Some(Some(Some(42)))
  let flattened = flatten_double_nested_option(nestedSome)
  assert_eq(flattened, Some(42))
}