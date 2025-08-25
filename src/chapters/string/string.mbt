
pub fn return_multi_line_string() -> String {
  let s = "Hello, World!"
  println(s)

  // Multi-line string
  let b =
    #| Hello
    #| MoonBit
    #| On multi lines
    #| With single indent

  let name = "Mr Moon"
  let template_string = "Hello, \{name}!"
  println(template_string)

  return b
}


pub fn greeting(name: String) -> String {
  let template_string = "Hello, \{name}!"
  return template_string
}


pub fn split_into_charsA(s: String) -> Array[Char] {
  return Array::from_iter(s.iter())
}

pub fn split_into_charsB(s: String) -> Array[Char] {
  let len = s.length()
  return Array::makei(len, i => {
    let c: Char? = s[i].to_char()  
    return c.unwrap_or_else(fn () -> Char {
      return '?'
    })
  })
}

pub fn split_into_charsC(s: String) -> Array[Char] {
  let arr: Array[Char] = [];
  for char in s.iter() {
    arr.push(char)
  }
  return arr
}