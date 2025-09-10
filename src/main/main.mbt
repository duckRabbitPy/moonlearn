

fn main {
  // Access command line arguments using env package
  let args = @env.args()
  println("Command line arguments:")
  if args.length() > 0 {
    for arg in args {
      println("  " + arg)
    }
  } else {
    println("  No arguments provided")
  }
  
  // Original code
  println(@lib.hello())
  println(@json.parse_json("{\"key\": 42}"))
  @boolean.print_boolean()
  @unit.print_hello_unit()
  @boolean.print_boolean()
  println(@partial_application.full_add_function(10, 20))
  println(@map.array_to_map([1, 2, 3]))
  println(@option.some_or_default(Some(42), 0))
  println(@result.result_is_ok(Ok(42)))
  println(@number.addAny(1, 2))
  println(@tuple.sum_tuple(1, 2, c=3))
  println(@ref.new(1))
  println(@string.greeting("John"))
  println(@array.fill(1, 3))
  println(@byte.return_literal_bytesA())
  println(@loop.double_array_loop([1, 2, 3, 4, 5]))
  println(@defer.defer_example(@ref.new("initial value")))
}



