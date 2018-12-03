use std::fs;

fn main() {
  let input: String = fs::read_to_string("../ruby/day1.txt")
                          .expect("Unable to read File");
  let sum: i32 = input.trim()
                      .lines()
                      .to_integers()
                      .sum();
  println!("{}", sum);
}

fn to_integers(iter: I)
{
  iter.map(|s: &str| parse_number(s) )
}

fn parse_number(number: &str) -> i32
{
  number.parse::<i32>().unwrap()
}
