pub fn sum_tuple(a: Int, b: Int, c?: Int, d?: Int) -> Int {
    let result = match (a, b, c, d) {
        (a, b, Some(c), Some(d)) => a + b + c + d
        (a, b, Some(c), None) => a + b + c
        (a, b, None, Some(d)) => a + b + d
        (a, b, None, None) => a + b
    }
    return result
}

