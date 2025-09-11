test "encode and decode" { 
  let input = "Hello, world!"
  let encode_result = @code.encode(input)
  
  assert_eq(encode_result.contains("ciphertext"), true)
  assert_eq(encode_result.contains("key"), true)
  let decode_result = @code.decode(encode_result)
  println("result: " + decode_result)
  assert_eq(decode_result, "Hello, world!")
}