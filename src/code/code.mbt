pub fn encode(plaintext: String) -> String {
  let plaintextBytes = plaintext.to_bytes()
  let randomGenerator = @random.Rand::new()
  let keyBytes = []
  
  let cipherBytes = plaintextBytes.iter().map(byte => {
    let keyByte = randomGenerator.int(limit=256)
    keyBytes.push(keyByte.to_byte())
    // xor the byte with the key byte
    return byte ^ keyByte.to_byte()
  })

  let ciphertextString = cipherBytes.iter().map(byte => {
    let hexValue = byte.to_int()
    intToHex(hexValue)
  }).join(":")
  
  let keyString = keyBytes.iter().map(byte => {
    let hexValue = byte.to_int()
    intToHex(hexValue)
  }).join(":")

  let json: Json = { "ciphertext": ciphertextString, "key": keyString }
  return Json::stringify(json)
}

fn intToHex(value: Int) -> String {
  let hexChars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
  let high = value / 16
  let low = value % 16
  let highChar = hexChars[high]
  let lowChar = hexChars[low]
  highChar.to_string() + lowChar.to_string()
}

fn hexCharsToByte(hexChars: Array[Char]) -> Byte {
  let mut result = 0
    for char in hexChars.iter() {
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
        'A' => 10
        'B' => 11
        'C' => 12
        'D' => 13
        'E' => 14
        'F' => 15
        'a' => 10
        'b' => 11
        'c' => 12
        'd' => 13
        'e' => 14
        'f' => 15
        _ => 0
      }
      result = result * 16 + digit
    }
  return result.to_byte()
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

fn decode(plaintext: String) -> String {
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

      let cipherBytes = ciphertextString.split(":").map(hexStr => {
        let hexChars = hexStr.to_string().to_array()
        return hexCharsToByte(hexChars)
      }).collect()

      let keyBytes = keyString.split(":").map(hexStr => {
        let hexChars = hexStr.to_string().to_array()
        return hexCharsToByte(hexChars)
      }).collect()

      let readableChars = cipherBytes.mapi((index, cipherByte) => {
        let keyByte = keyBytes[index]
        // xor the cipher byte with the key byte
        let decryptedByte = cipherByte ^ keyByte
        decryptedByte.to_char().to_string()
      }).join("")

      return readableChars
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

