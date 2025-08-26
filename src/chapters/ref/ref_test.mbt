test "swap_ref" {
    let r1 = @ref.new("first")
    let r2 = @ref.new("second")

  let mut original_r1 = ""
  r1.protect(r1.val, () => {
    original_r1= r1.val
  })

  let mut original_r2 = ""
  r2.protect(r2.val, () => {
    original_r2= r2.val
  })

  let swapped = @ref.swap_ref(r1, r2)


  assert_eq(original_r1, "first")
  assert_eq(original_r2, "second")
  assert_eq((swapped.0.val, swapped.1.val), (original_r2, original_r1))

}


test "map_numerical_ref" {
  let num = @ref.new(10)
  let result = @ref.map_numerical_ref(num, (x) => { x * 2 })
  assert_eq(result.val, 20)
}