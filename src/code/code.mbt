// FFI Javascript functions
#external
priv type JsArray
fn make_js_array() -> JsArray = "custom_module" "make_js_array"
fn push_js_array(array : JsArray, value: Byte) -> JsArray= "custom_module" "push_js_array"
fn append_to_key_store(array : JsArray) -> Int = "custom_module" "append_to_key_store"

pub fn encode(plaintext: String) -> String {
  let plaintextBytes = plaintext.to_bytes()
  let randomGenerator = @random.Rand::new()
  let keyBytes = []

  let currJsArray = make_js_array()
  
  let cipherBytes = plaintextBytes.iter().map(byte => {
    let keyByte = randomGenerator.int(limit=256)
    keyBytes.push(keyByte.to_byte())
    // xor the byte with the key byte
    return byte ^ keyByte.to_byte()
  })

  let ciphertextString = cipherBytes.iter().map(byte => {
    return byte.to_int().to_string()
  }).join(":")

  let keyString = keyBytes.iter().map(byte => {
    let _ = push_js_array(currJsArray, byte)
    return  byte.to_int().to_string()
  }).join(":")

  let _ = append_to_key_store(currJsArray)

  let json: Json = { "ciphertext": ciphertextString, "key": keyString }
  return Json::stringify(json)
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

priv struct EncodedJson {
  ciphertext: String
  key: String
}

pub fn decode(plaintext: String) -> String {
  let json = parse_json(plaintext)

  let encodedJson = match json {
    Ok(json) => {
      let ciphertextString = json.value("ciphertext").unwrap().as_string().unwrap()
      let keyString = json.value("key").unwrap().as_string().unwrap()
      Ok(EncodedJson::{ ciphertext: ciphertextString, key: keyString })
    }
    Err(err) => Err(err)
  }

  match encodedJson {
    Ok(encodedJson) => {
      let ciphertextString = encodedJson.ciphertext
      let keyString = encodedJson.key

      let cipherBytes = ciphertextString.split(":").map(strInt => {
        return parse_string_to_int(strInt.to_string()).to_byte()
      }).collect()

      let keyBytes = keyString.split(":").map(strInt => {
        return parse_string_to_int(strInt.to_string()).to_byte()
      }).collect()

      let decryptedChars = cipherBytes.mapi((index, cipherByte) => {
        let keyByte = keyBytes[index]
        // xor the cipher byte with the key byte
        let decryptedByte = cipherByte ^ keyByte
        decryptedByte.to_char()
      })
    
      // to_char() produces UTF-16 characters with null padding.
      // remove null characters
      let filteredChars = decryptedChars.filter(char => char != '\u{00}')
      let stringChars = filteredChars.map(char => char.to_string())
      stringChars.join("")
    }
    Err(err) => "Failed to decode: " + err
  }
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

