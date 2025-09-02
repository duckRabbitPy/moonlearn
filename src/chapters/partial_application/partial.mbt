

pub fn full_add_function(a: Int, b: Int) -> Int {
  return a + b
}


//method, baseUrl, endpoint, data
pub fn fetch(_method: String, _url: String, _data: Json) -> Result[Json, String] {
  let map : Map[String, Json] = { "response": "success" }
  let mock_json = Json::object(map)
  return Ok(mock_json)
}

pub fn makeRequest(f_method: String, baseUrl: String, endpoint: String, data: Json) -> Result[Json, String] {
  return fetch(f_method, baseUrl + endpoint, data)
}

