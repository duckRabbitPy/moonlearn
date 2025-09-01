test "parse_json" {
  let json_string = "{\"key\": 42}"
  assert_eq(@json.is_valid_json_string(json_string), true)
  let result = @json.parse_json(json_string)
  match result {
    Ok(json) => {
      let key_option = json.value("key").unwrap().as_number()
      assert_eq(key_option, Some(42))
    }
    Err(error) => fail(error)
  }
}


test "getItemAtJsonStringIndex" {
  let json_string = "[42, \"hello\", true]"
  let result42 = getItemAtJsonStringIndex(json_string, 0)
  match result42 {
    Ok(item) => assert_eq(item, ItemType::ItemNumber(42.0))
    Err(error) => fail(error)
  }

  let resultHello = getItemAtJsonStringIndex(json_string, 1)
  match resultHello {
    Ok(item) => assert_eq(item, ItemType::ItemString("hello"))
    Err(error) => fail(error)
  }

  let resultTrue = getItemAtJsonStringIndex(json_string, 2)
  match resultTrue {
    Ok(item) => assert_eq(item, ItemType::ItemBool(true))
    Err(error) => fail(error)
  }
}