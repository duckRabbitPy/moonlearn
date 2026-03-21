

pub fn full_add_function(a: Int, b: Int) -> Int {
  return a + b
}


/// Mock request: `(method, full_url, body)` — ignores inputs, returns a fixed JSON success.
pub fn fetch(_method: String, _url: String, _data: Json) -> Result[Json, String] {
  let map : Map[String, Json] = { "response": "success" }
  let mock_json = Json::object(map)
  return Ok(mock_json)
}

/// Builds full URL as `baseUrl + endpoint` and delegates to `fetch`.
pub fn makeRequest(f_method: String, baseUrl: String, endpoint: String, data: Json) -> Result[Json, String] {
  return fetch(f_method, baseUrl + endpoint, data)
}

