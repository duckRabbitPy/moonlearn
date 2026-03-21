test "defer_example" {  

  let reference = defer_example(@defer.string_ref("initial value"))
  assert_eq(reference.val, "updated value")
}