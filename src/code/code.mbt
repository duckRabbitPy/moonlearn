// FFI Javascript functions
#external
priv type JsArray
#external
priv type JsString
fn make_js_array() -> JsArray = "custom_module" "make_js_array"
fn push_js_array(array : JsArray, value: Byte) -> JsArray= "custom_module" "push_js_array"
fn append_to_key_store(array : JsArray) -> Int = "custom_module" "append_to_key_store"
fn read_cipher_from_file(lineNumber: Int) -> JsString = "custom_module" "read_cipher_from_file"
fn get_byte_from_js_string(jsString: JsString, index: Int) -> Byte = "custom_module" "get_byte_from_js_string"


// Pure functions
pub fn encrypt_bytes(plaintextBytes: Array[Byte], keyBytes: Array[Byte]) -> Array[Byte] {
  plaintextBytes.mapi((index, byte) => {
    let keyByte = keyBytes[index]
    return byte ^ keyByte
  })
}

pub fn bytes_to_ciphertext_string(bytes: Array[Byte]) -> String {
  bytes.iter().map(byte => {
    return byte.to_int().to_string()
  }).join(":")
}

pub fn create_encrypted_json(ciphertext: String, key: String) -> String {
  let json: Json = { "ciphertext": ciphertext, "key": key }
  return Json::stringify(json)
}



pub fn encode_pure(plaintext: String) -> (String, Array[Byte]) {
  let plaintextBytes = plaintext.to_bytes()
  let randomGenerator = @random.Rand::new()
  let keyBytes = []
  
  // Generate random keys
  for _ in plaintextBytes.iter() {
    let keyByte = randomGenerator.int(limit=256)
    keyBytes.push(keyByte.to_byte())
  }
  
  let keyString = bytes_to_ciphertext_string(keyBytes)
  
  return (keyString, keyBytes)
}

fn parse_string_to_int(s: String) -> Int {
  let mut result = 0
  for char in s.iter() {
    let digit = match char {
      '0' => 0
      '1' => 1
      '2' => 2
      '3' => 3
      '4' => 4
      '5' => 5
      '6' => 6
      '7' => 7
      '8' => 8
      '9' => 9
      _ => 0
    }
    result = result * 10 + digit
  }
  return result
}

fn parse_json(jsonStr: String) -> Result[Json, String] {
  let res = try? (@json.parse(jsonStr)) 
  match res {
    Ok(json) => Ok(json)
    Err(_) => Err("Failed to parse JSON")
  }
}


pub fn ciphertext_string_to_bytes(ciphertextString: String) -> Array[Byte] {
  ciphertextString.split(":").map(strInt => {
    return parse_string_to_int(strInt.to_string()).to_byte()
  }).collect()
}

pub fn decrypt_bytes(cipherBytes: Array[Byte], lineNumber: Int) -> Array[Byte] {
  // Fetch key from file using line number
  let keyJsString = read_cipher_from_file(lineNumber)
  
  // Decrypt each cipher byte by XORing with corresponding key byte
  return cipherBytes.mapi((index, cipherByte) => {
    let keyByte = get_byte_from_js_string(keyJsString, index)
    return cipherByte ^ keyByte
  })
}

pub fn decrypted_bytes_to_string(decryptedBytes: Array[Byte]) -> String {
  let decryptedChars = decryptedBytes.map(byte => {
    byte.to_char()
  })
  
  // to_char() produces UTF-16 characters with null padding.
  // remove null characters
  let filteredChars = decryptedChars.filter(char => char != '\u{00}')
  let stringChars = filteredChars.map(char => char.to_string())
  stringChars.join("")
}


pub fn decode_else_error(jsonStr: String) -> Result[String, String] {
  let json = parse_json(jsonStr)
  
  match json {
    Ok(json) => {
      let lineNumber = json.value("id").unwrap().as_number().unwrap().to_int()
      let ciphertextString = json.value("ciphertext").unwrap().as_string().unwrap()
      
      let cipherBytes = ciphertext_string_to_bytes(ciphertextString)
      
      let decryptedBytes = decrypt_bytes(cipherBytes, lineNumber)
      let result = decrypted_bytes_to_string(decryptedBytes)
      
      Ok(result)
    }
    Err(err) => Err("Failed to parse JSON: " + err)
  }
}

pub fn decode(plaintext: String) -> String {
  match decode_else_error(plaintext) {
    Ok(result) => result
    Err(err) => "Failed to decode: " + err
  }
}


// !! Has side effects, calls ffi functions
pub fn encode(plaintext: String) -> String {
  let plaintextBytes = plaintext.to_bytes()
  let randomGenerator = @random.Rand::new()
  let keyBytes = []
  
  // Generate random keys
  for _ in plaintextBytes.iter() {
    let keyByte = randomGenerator.int(limit=256)
    keyBytes.push(keyByte.to_byte())
  }
  
  let plaintextArray = plaintextBytes.iter().collect()
  let cipherBytes = encrypt_bytes(plaintextArray, keyBytes)
  
  // Store KEY bytes in file (for later retrieval)
  let currJsArray = make_js_array()
  for keyByte in keyBytes.iter() {
    let _ = push_js_array(currJsArray, keyByte)
  }
  let numberOfLines = append_to_key_store(currJsArray)
  
  // Return ciphertext + id (line number)
  let ciphertextStr = bytes_to_ciphertext_string(cipherBytes)
  let json: Json = { "ciphertext": ciphertextStr, "id": numberOfLines - 2 }
  return json.stringify()
}

pub fn handle_code_command() -> Unit {
  let args = @env.args()
  let flag = args[0]
  let plaintext = args.split_at(1).1.join(" ")

 let result = match flag {
    "-e" => encode(plaintext) // e.g. "Hello"
    "-d" => decode(plaintext) // json string e.g '{"ciphertext":"205:60:25:214:193:121:82:79:201:106","id":4}'
    _ => "Invalid flag"
  }

  println(result)
}

