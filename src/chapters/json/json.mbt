pub fn parse_json(jsonStr: String) -> Result[Json, String] {
  let res = try? (@json.parse(jsonStr)) 
  match res {
    Ok(json) => Ok(json)
    Err(_) => Err("Failed to parse JSON")
  }
}


pub fn is_valid_json_string(jsonStr: String) -> Bool {
  return @json.valid(jsonStr)
}


pub fn stringify_json(json: Json) -> String {
  return Json::stringify(json)
}


pub(all) enum ItemType {
  ItemNumber(Double)
  ItemString(String)
  ItemBool(Bool)
} derive(Eq, Show)

fn json_to_item_type(json: Json) -> Result[ItemType, String] {
  if(json.as_number() is Some(_)) {
    return Ok(ItemType::ItemNumber(json.as_number().unwrap()))
  }
  if(json.as_string() is Some(_)) {
    return Ok(ItemType::ItemString(json.as_string().unwrap()))
  } 
  if(json.as_bool() is Some(_)) {
    return Ok(ItemType::ItemBool(json.as_bool().unwrap()))
  } 
  else {
    return Err("Unsupported type")
  }
}

pub fn getItemAtJsonStringIndex(jsonStr: String, index: Int) -> Result[ItemType, String] {
  let maybeArray = parse_json(jsonStr)
  
  match maybeArray {
    Ok(array) => {
      match array.item(index) {
        Some(item) => json_to_item_type(item)
        None => Err("No item at index")
      }
    }
    Err(err) => Err(err)
  }
}