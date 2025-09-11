// FFI Javascript functions
#external
priv type JsArray
fn make_js_array() -> JsArray = "custom_module" "make_js_array"
fn push_js_array(array : JsArray, value: Byte) -> JsArray= "custom_module" "push_js_array"
fn append_to_key_store(array : JsArray) -> Int = "custom_module" "append_to_key_store"


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
  
  let plaintextArray = plaintextBytes.iter().collect()
  let cipherBytes = encrypt_bytes(plaintextArray, keyBytes)
  let ciphertextString = bytes_to_ciphertext_string(cipherBytes)
  let keyString = bytes_to_ciphertext_string(keyBytes)
  
  let jsonStr = create_encrypted_json(ciphertextString, keyString)
  return (jsonStr, keyBytes)
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

pub fn decrypt_bytes(cipherBytes: Array[Byte], keyBytes: Array[Byte]) -> Array[Byte] {
  cipherBytes.mapi((index, cipherByte) => {
    let keyByte = keyBytes[index]
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
      let ciphertextString = json.value("ciphertext").unwrap().as_string().unwrap()
      let keyString = json.value("key").unwrap().as_string().unwrap()
      
      let cipherBytes = ciphertext_string_to_bytes(ciphertextString)
      let keyBytes = ciphertext_string_to_bytes(keyString)
      
      let decryptedBytes = decrypt_bytes(cipherBytes, keyBytes)
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
  let (jsonStr, keyBytes) = encode_pure(plaintext)
  
  // FFI side effects
  let currJsArray = make_js_array()
  for keyByte in keyBytes.iter() {
    let _ = push_js_array(currJsArray, keyByte)
  }
  let _ = append_to_key_store(currJsArray)
  
  return jsonStr
}

pub fn handle_code_command() -> Unit {
  let args = @env.args()
  let flag = args[0]
  let plaintext = args.split_at(1).1.join(" ")

 let result = match flag {
    "-e" => encode(plaintext)
    "-d" => decode(plaintext)
    _ => "Invalid flag"
  }

  println(result)
}

