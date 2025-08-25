pub fn print_number() -> Unit {

  let int16 : Int16 = (42 : Int16)
  let int : Int = 42
  let int64 : Int64 = 1000L
  let uint16 : UInt16 = (14 : UInt16)
  let uint : UInt = 14U
  let uint64 : UInt64 = 14UL
  let double : Double = 3.14
  let float : Float = (3.14 : Float)
  let bigint : BigInt = 10000000000000000000000N

  println(int16)
  println(int)
  println(int64)
  println(uint16)
  println(uint)
  println(uint64)
  println(double)
  println(float)
  println(bigint)

  }

pub fn [T: Add]addAny (a: T, b: T) -> T {
  a + b
}

pub fn [T: Mul]multiplyAny (a: T, b: T) -> T {
  a * b
}

pub fn [T: Div]divideAny (a: T, b: T) -> T {
  a / b
}

pub fn [T: Mod]modAny (a: T, b: T) -> T {
  a % b
}