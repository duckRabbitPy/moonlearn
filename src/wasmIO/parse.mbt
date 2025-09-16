#external
priv type JsString
#external
priv type JsByteArray

fn read_string_from_file() -> JsString = "custom_module" "read_string_from_file"
fn js_string_length(s: JsString) -> Int = "custom_module" "js_string_length"
fn js_string_char_at(s: JsString, i: Int) -> Char = "custom_module" "js_string_char_at"

fn make_js_byte_array() -> JsByteArray = "custom_module" "make_js_byte_array"
fn push_to_js_byte_array(byteArray: JsByteArray, byte: Byte) -> JsByteArray = "custom_module" "push_to_js_byte_array"
fn write_byte_array_to_string_store(byteArray: JsByteArray) -> Unit = "custom_module" "write_byte_array_to_string_store"

fn read_in_memory_string() -> JsString = "custom_module" "read_in_memory_string"
fn write_to_in_memory_string(s: JsByteArray) -> Unit = "custom_module" "write_to_in_memory_string"
fn print_in_memory_string() -> Unit = "custom_module" "print_in_memory_string"

// construct moonbit string from js string
fn js_string_to_string(s: JsString) -> String {
  let len = js_string_length(s)
  let mut result = ""
  let mut i = 0
  while i < len {
    let char = js_string_char_at(s, i)
    result = result + char.to_string()
    i = i + 1
  }
  result
}

fn build_js_byte_array_from_string(s: String) -> JsByteArray {
  let mut byteArray = make_js_byte_array()
  let bytes = s.to_bytes()
  for byte in bytes.iter() {
    byteArray = push_to_js_byte_array(byteArray, byte)
  }
  byteArray
}

pub fn alter_string_from_file() -> Unit {
  let jsString = read_string_from_file()
  let str = js_string_to_string(jsString)

  let byteArray = build_js_byte_array_from_string(str.add(" with a sprinkle of moonbit"))
  write_byte_array_to_string_store(byteArray)
  println(str)
}


pub fn alter_string_from_memory() -> Unit {
  let jsString = read_in_memory_string()
  let str = js_string_to_string(jsString)

  let byteArray = build_js_byte_array_from_string(str.add(" with a sprinkle of moonbit"))
  write_to_in_memory_string(byteArray)
  print_in_memory_string()
}

