test "extractValuesFromMap" {
  assert_eq(@map.extractValuesFromMap(["a", "b", "c"], {"a": 1, "b": 2, "c": 3, "d": 4}), [1, 2, 3])
}

test "extractKeysFromMap" {
  assert_eq(@map.extractKeysFromMap([1, 2, 3], {"a": 1, "b": 2, "c": 3, "d": 4}), ["a", "b", "c"])
}

test "array_to_map" {
  assert_eq(@map.array_to_map(["a", "b", "c"]), {0: "a", 1: "b", 2: "c"})
}