pub fn parse_json(jsonStr: String) -> Result[Json, String] {
  let res = try? (@core_json.parse(jsonStr))
  match res {
    Ok(json) => Ok(json)
    Err(_) => Err("Failed to parse JSON")
  }
}

pub(all) struct Coordinates {
  latitude : String
  longitude : String
} derive(Eq, Show)

pub(all) struct User {
  gender : String
  name : String
  first : String
  last : String
  state : String
  country : String
  postcode : Double
  coordinates : Coordinates
} derive(Eq, Show)




fn decode_user_array(json : Json) -> Result[Array[User], String] {
  guard json is Object(obj) else { return Err("Root is not an object") }

  let results = obj.get("results")
  guard results is Some(Array(arr)) else { return Err("Results is not an array") }
  Ok(
    arr.filter_map(item => {
      let user = json_to_user(item)
      match user {
        Ok(user) => Some(user)
        Err(_) => None
      }
    }),
  )
}

//  Some(Object({"latitude": String("-23.9209"), "longitude": String("-21.4224")}))
fn decode_coordinates(obj: Map[String, Json]) -> Result[Coordinates, String] {
  let latitude = match obj.get("latitude") {
    Some(String(s)) => s
    _ => return Err("Latitude is not a string")
  }
  let longitude = match obj.get("longitude") {
    Some(String(s)) => s
    _ => return Err("Longitude is not a string")
  }
  Ok(Coordinates::{ latitude: latitude.to_string(), longitude: longitude.to_string() })
}


fn json_to_user(json: Json) -> Result[User, String] {
  guard json is Object(obj) else { return Err("Root is not an object") }

  let gender = match obj.get("gender") {
    Some(String(s)) => s
    _ => return Err("Gender is not a string")
  }

  let nameObj = match obj.get("name") {
    Some(Object(o)) => o
    _ => return Err("Name is not an object")
  }

  let first = match nameObj.get("first") {
    Some(String(s)) => s
    _ => return Err("First name is not a string")
  }
  let last = match nameObj.get("last") {
    Some(String(s)) => s
    _ => return Err("Last name is not a string")
  }
  let name = first + " " + last

  let location = match obj.get("location") {
    Some(Object(o)) => o
    _ => return Err("Location is not an object")
  }

  let state = match location.get("state") {
    Some(String(s)) => s
    _ => return Err("State is not a string")
  }
  let country = match location.get("country") {
    Some(String(s)) => s
    _ => return Err("Country is not a string")
  }
  let postcode = match location.get("postcode") {
    Some(Number(n, ..)) => n
    _ => return Err("Postcode is not a number")
  }
  let coordinates = {
     match location.get("coordinates") {
      Some(Object(o)) => decode_coordinates(o).unwrap_or(Coordinates::{ latitude: "0.0", longitude: "0.0" })
      _ => return Err("Coordinates is not an object")
    }
  }

  Ok(User::{
    gender: gender,
    name: name,
    first: first,
    last: last,
    state: state,
    country: country,
    postcode: postcode,
    coordinates: coordinates,
  })
}

async test "https request" {
  let (response, body) = @async.retry(FixedDelay(250), max_retry=3, () => {
    @async.with_timeout(3000, () => @http.get("https://randomuser.me/api/"))
  })

  let json = parse_json(body.text())
  match json {
    Ok(json) => {
      let users = decode_user_array(json)
      match users {
        Ok(users) => println(users)
        Err(error) => println("Error: " + error)
      }
    }
    Err(error) => println("Error: " + error)
  }
  assert_true(response.code is (200..<300))
}