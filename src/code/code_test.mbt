test "pure encoding and decoding" { 
  let input = "Hello, world!"
  let (encode_result, _) = @code.encode_pure(input)
  
  assert_eq(encode_result.contains("ciphertext"), true)
  assert_eq(encode_result.contains("key"), true)
  
  match @code.decode_else_error(encode_result) {
    Ok(decode_result) => {
      println("result: " + decode_result)
      assert_eq(decode_result, "Hello, world!")
    }
    Err(err) => {
      println("Decode error: " + err)
      assert_eq(false, true) // Force test failure
    }
  }
}

test "encrypt_bytes function" {
  let plaintext = [104, 101, 108, 108, 111].map(i => i.to_byte()) // "hello"
  let key = [200, 150, 100, 50, 25].map(i => i.to_byte())
  let encrypted = @code.encrypt_bytes(plaintext, key)
  let decrypted = @code.decrypt_bytes(encrypted, key)
  
  assert_eq(decrypted, plaintext)
}

test "bytes_to_ciphertext_string and back" {
  let bytes = [104, 101, 108, 108, 111].map(i => i.to_byte())
  let string = @code.bytes_to_ciphertext_string(bytes)
  let back_to_bytes = @code.ciphertext_string_to_bytes(string)
  
  assert_eq(back_to_bytes, bytes)
}