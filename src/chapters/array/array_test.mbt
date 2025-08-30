test "fill" {
  assert_eq(@array.fill(1, 3), [1, 1, 1])
}

test "consecutive_numbers" {
  assert_eq(@array.consecutive_numbers(1, 10), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
}

test "sortTupleArrayByKey" {
  assert_eq(@array.sortTupleArrayByKey([(3, 1), (2, 2), (1, 3)]), [(1, 3), (2, 2), (3, 1)])
}

test "sortNumbers" {
  assert_eq(@array.sortNumbers([3, 2, 1], Ascending), [1, 2, 3])
  assert_eq(@array.sortNumbers([3, 2, 1], Descending), [3, 2, 1])
}