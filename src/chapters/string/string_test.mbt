test "print_string" {
  assert_eq(@string.return_multi_line_string(), " Hello\n MoonBit\n On multi lines\n With single indent")
  inspect(@string.return_multi_line_string(), content=" Hello\n MoonBit\n On multi lines\n With single indent")
}

test "greeting" {
  assert_eq(@string.greeting("Mr Moon"), "Hello, Mr Moon!")
}

test "split_into_chars" {
  assert_eq(@string.split_into_charsA("Hello"), ['H', 'e', 'l', 'l', 'o'])
}

test "split_into_charsB" {
  assert_eq(@string.split_into_charsB("Hello"), ['H', 'e', 'l', 'l', 'o'])
}

test "split_into_charsC" {
  assert_eq(@string.split_into_charsC("Hello"), ['H', 'e', 'l', 'l', 'o'])
}

