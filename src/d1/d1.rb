# frozen_string_literal: true

def d1(input)
  lett_digits = {
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  re = /(?=(#{lett_digits.keys.join('|')}|\d))/i

  input.reduce(0) do |acc, str|
    digits =
      str
        .scan(re)
        .flatten
        .map { |match| lett_digits.fetch(match, match) }
        .compact

    num = "#{digits.first}#{digits.last}".to_i
    acc + num
  end
end

test_part_one = %w[
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
]

test_part_two = %w[
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
]

puts d1(test_part_one)
puts d1(test_part_two)

# Large puzzle input
file = File.open("d1.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts d1(file_data)
