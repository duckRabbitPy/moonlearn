

test "partial_add_function" {
  // First argument fixed at 10; second argument is passed when you call `add10`.
  // `add10(y)` means `full_add_function(10, y)`.
  let add10 = x => full_add_function(10, x)
  assert_eq(add10(20), 30)
}


test "makeRequest" {
  // Method and base URL are fixed; `endpoint` and `data` are passed when you call each function.
  let apiPost = (endpoint, data) =>
    makeRequest("POST", "https://api.myapp.com", endpoint, data)
  let apiGet = (endpoint, data) =>
    makeRequest("GET", "https://api.myapp.com", endpoint, data)

  let userMap : Map[String, Json] = { "name": "John", "age": 42.0 }
  // Call the closures with the path and JSON body
  let result = apiPost("/users", Json::object(userMap))
  assert_eq(result, Ok(Json::object({ "response": "success" })))

  let userMap2 : Map[String, Json] = { "name": "Jane", "age": 30.0 }
  let result2 = apiGet("/users/123", Json::object(userMap2))
  assert_eq(result2, Ok(Json::object({ "response": "success" })))
}