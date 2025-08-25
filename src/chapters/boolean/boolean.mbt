

pub fn print_boolean() -> Unit {
  let a = true;
  let b = false;
  let c = a && b;
  let d = a || b;
  let e = not(a);

  println(a)
  println(b)
  println(c)
  println(d)
  println(e)
}
