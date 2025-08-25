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


// MoonBit has 4 visibility levels:
//   - priv - private (invisible outside)
//   - default - abstract (name visible, construction hidden)
//   - pub(readonly) - read-only (visible but no construction/mutation)
//   - pub(all) - fully public (construct, modify, read freely)

pub(all) enum CustomNumber {
  UnsignedNumber(UInt)
  SignedNumber(Int)
} derive(Eq)


pub fn addCustomNumber (a: CustomNumber, b: CustomNumber) -> CustomNumber raise Failure {
  match (a, b) {
    (UnsignedNumber(a), UnsignedNumber(b)) => UnsignedNumber(a + b)
    (SignedNumber(a), SignedNumber(b)) => SignedNumber(a + b)
    _ => raise Failure("FAILED: cannot add signed and unsigned numbers")
  }
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