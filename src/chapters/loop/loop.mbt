

// while loop
pub fn double_array_while(array: Array[Int]) -> Array[Int] {
 let mut i = 0
  while i < array.length() {
    array[i] = array[i] * 2
    i = i + 1
  }
  return array
}


// for loop
pub fn double_array_for(array: Array[Int]) -> Array[Int] {
  for i = 0; i < array.length(); i = i + 1 {
    array[i] = array[i] * 2
  }
  return array
}



// for .. in loop
pub fn double_array_for_in(array: Array[Int]) -> Array[Int] {
  let arr = array.copy()
  for i in array {
    arr[i] = array[i] * 2
  }
  return arr
  }


// loop keyword
pub fn double_array_loop(array: Array[Int]) -> Array[Int] {
  let result = array.copy()
  let startIndex = 0
  loop (startIndex) {
    i => if i >= result.length() {
      break result
    } else {
      result[i] = result[i] * 2
      continue (i + 1)
    }
  }
}
