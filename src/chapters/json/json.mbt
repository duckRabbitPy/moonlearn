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
  if json is Number(n, ..) {
    return Ok(ItemType::ItemNumber(n))
  }
  if json is String(s) {
    return Ok(ItemType::ItemString(s))
  } 
  if json is True {
    return Ok(ItemType::ItemBool(true))
  }
  if json is False {
    return Ok(ItemType::ItemBool(false))
  }
  else {
    return Err("Unsupported type")
  }
}

pub fn getItemAtJsonStringIndex(jsonStr: String, index: Int) -> Result[ItemType, String] {
  let maybeArray = parse_json(jsonStr)
  
  match maybeArray {
    Ok(array) => {
      let item = if array is Array(arr) { arr.get(index) } else { None }
      match item {
        Some(item) => json_to_item_type(item)
        None => Err("No item at index")
      }
    }
    Err(err) => Err(err)
  }
}