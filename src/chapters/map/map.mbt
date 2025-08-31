pub fn extractValuesFromMap(keys: Array[String], map: Map[String, Int], ) -> Array[Int] {
  return keys.map(key => map.get(key)).filter_map(value => value)
}

pub fn extractKeysFromMap(values: Array[Int], map: Map[String, Int], ) -> Array[String] {
  return map.keys().filter(key => {
    let value = map.get(key)
    return match value {
      Some(value) => values.contains(value)
      None => false
    }
  }).to_array()
}

pub fn [T]array_to_map(array: Array[T]) -> Map[Int, T] {
  let map: Map[Int, T] = Map::new()
  return array.foldi(init = map, (index, acc, value) => {
    acc.set(index, value)
    return acc
  })
}

// T must implement Eq
pub fn [T: Eq]has_kvp(map: Map[String, T], kvp: (String, T)) -> Bool {
  let (key, value) = kvp
  return map.contains_kv(key, value)
}