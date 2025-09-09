pub fn update_reference(reference: Ref[String]) -> Unit {
  reference.val = "updated value"
}

pub fn defer_example(reference: Ref[String]) -> Ref[String] {
  defer update_reference(reference)
  println("reference.val before exiting function: \{reference.val}")
  return reference
}
