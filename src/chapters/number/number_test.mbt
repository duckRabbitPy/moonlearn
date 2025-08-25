test "print_number" {
  if @number.addAny(10000000000000000000000N, 2) != 10000000000000000000002N {
    fail("10000000000000000000000N + 2 != 10000000000000000000002N")
  }

  if @number.addCustomNumber(@number.CustomNumber::SignedNumber(2), @number.CustomNumber::SignedNumber(3)) != @number.CustomNumber::SignedNumber(5) {
    fail("1 + 2 != 3")
  }

  

}
