# frozen_string_literal: true

def day6_part_two(input)
  last = input[0].scan(/(\d+)/).flatten.join.to_i
  distance = input[1].scan(/(\d+)/).flatten.join.to_i

  (1...last).reduce(0) do |acc, secs_held|
    next acc unless secs_held * (last - secs_held) > distance

    acc + 1
  end
end

test = <<~INPUT
  Time:      7  15   30
  Distance:  9  40  200
INPUT
  .split(/\n/)

puts day6_part_two(test)

file = File.open("d6.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day6_part_two(file_data)
