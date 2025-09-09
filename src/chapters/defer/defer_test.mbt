test "defer_example" {  

  let reference = defer_example(@ref.new("initial value"))
  assert_eq(reference.val, "updated value")
}