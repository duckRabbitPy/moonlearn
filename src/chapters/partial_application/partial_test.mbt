

test "partial_add_function" {
  // a argument is provided
  // b argument is not provided, so it is partial application
  // when we call add10 the first argument to add10 is b in the full_add_function
  let add10 = full_add_function(10, _)
  assert_eq(add10(20), 30)
}


test "makeRequest" {
  // use partial application to create specialized functions with default method and baseUrl
  // endpoint and data are not provided
  let apiPost = makeRequest("POST", "https://api.myapp.com", _, _)
  let apiGet = makeRequest("GET", "https://api.myapp.com", _, _)

  let userMap : Map[String, Json] = { "name": "John", "age": 42.0 }
  // then we call the partial functions with the remaining arguments (endpoint and data)
  let result = apiPost("/users", Json::object(userMap))
  assert_eq(result, Ok(Json::object({ "response": "success" })))

  let userMap2 : Map[String, Json] = { "name": "Jane", "age": 30.0 }
  let result2 = apiGet("/users/123", Json::object(userMap2))
  assert_eq(result2, Ok(Json::object({ "response": "success" })))
}