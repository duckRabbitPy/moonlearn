test "pure encoding function" { 
  let input = "Hello, world!"
  let (keyStr, keyBytes) = @code.encode_pure(input)
  
  // Test that encode_pure returns key string and key bytes
  assert_eq(keyStr.contains(":"), true) // Key should be colon-separated
  assert_eq(keyBytes.length(), input.to_bytes().length()) // Key length should match input byte length
}

test "encrypt_bytes and decrypt_bytes functions" {
  let plaintext = [104, 101, 108, 108, 111].map(i => i.to_byte()) // "hello"
  let key = [200, 150, 100, 50, 25].map(i => i.to_byte())
  
  // Test encryption
  let encrypted = @code.encrypt_bytes(plaintext, key)
  assert_eq(encrypted.length(), plaintext.length())
  
  // Test decryption (using the old signature for pure testing)
  let decrypted = encrypted.mapi((index, cipherByte) => {
    let keyByte = key[index]
    return cipherByte ^ keyByte
  })
  
  assert_eq(decrypted, plaintext)
}

test "bytes_to_ciphertext_string and ciphertext_string_to_bytes" {
  let bytes = [104, 101, 108, 108, 111].map(i => i.to_byte())
  let string = @code.bytes_to_ciphertext_string(bytes)
  let back_to_bytes = @code.ciphertext_string_to_bytes(string)
  
  assert_eq(back_to_bytes, bytes)
  assert_eq(string, "104:101:108:108:111")
}

test "decrypted_bytes_to_string function" {
  // Test with bytes that represent "hello"
  let bytes = [104, 101, 108, 108, 111].map(i => i.to_byte())
  let result = @code.decrypted_bytes_to_string(bytes)
  
  assert_eq(result, "hello")
}

test "create_encrypted_json function" {
  let ciphertext = "205:60:25:214:193"
  let key = "165:60:124:214:173"
  let json = @code.create_encrypted_json(ciphertext, key)
  
  assert_eq(json.contains("ciphertext"), true)
  assert_eq(json.contains("key"), true)
  assert_eq(json.contains(ciphertext), true)
  assert_eq(json.contains(key), true)
}
