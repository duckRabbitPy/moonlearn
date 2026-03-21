async test "https request" {
  let (response, body) = @async.retry(FixedDelay(250), max_retry=3, () => {
    @async.with_timeout(3000, () => @http.get("https://www.moonbitlang.com"))
  })

  println(response)
  assert_true(response.code is (200..<300))
  assert_true(body.text().has_prefix("<!doctype html>"))
}