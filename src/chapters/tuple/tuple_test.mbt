test "sum_tuple" {
    // pass optional arguments with labels
    assert_eq(@tuple.sum_tuple(1, 2, c=3, d=4), 10)
    assert_eq(@tuple.sum_tuple(1, 2, c=3), 6)
    assert_eq(@tuple.sum_tuple(1, 2), 3)
    assert_eq(@tuple.sum_tuple(5, 5), 10)
}