pub fn[T] fill(value : T, times : Int) -> Array[T] {
  return Array::makei(times, _ => value)
}

pub fn consecutive_numbers(start: Int, end: Int) -> Array[Int] {
  return Array::makei(end - start + 1, i => start + i)
}


pub(all) enum SortOrder {
  Ascending
  Descending
}

pub fn sortNumbers(numbers : Array[Int], order : SortOrder) -> Array[Int] {
  let sorted = numbers.copy()
  sorted.sort();
  match order {
    Ascending => sorted
    Descending => {
      sorted.rev_inplace();
      return sorted
    }
  }
}

pub fn sortTupleArrayByKey(pairs : Array[(Int, Int)]) -> Array[(Int, Int)] {
  let sorted = pairs.copy()
  sorted.sort_by_key(p => p.0)
  return sorted
}