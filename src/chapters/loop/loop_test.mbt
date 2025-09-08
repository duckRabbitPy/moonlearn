test "double_array_loop" {
  let input = [1, 2, 3, 4, 5]
  let expected = [2, 4, 6, 8, 10]
  assert_eq(@loop.double_array_loop(input), expected)
}

test "double_array_while" {
  let input = [1, 2, 3, 4, 5]
  let expected = [2, 4, 6, 8, 10]
  assert_eq(@loop.double_array_while(input), expected)
}

test "double_array_for" {
  let input = [1, 2, 3, 4, 5]
  let expected = [2, 4, 6, 8, 10]
  assert_eq(@loop.double_array_for(input), expected)
}
