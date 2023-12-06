# frozen_string_literal: true

def day6_part_one(input)
  times = input[0].scan(/(\d+)/).flatten.map(&:to_i)
  distances = input[1].scan(/(\d+)/).flatten.map(&:to_i)

  races = times.zip(distances)

  races.map do |(last, record)|
    (1...last).reduce(0) do |acc, secs_held|
      next acc unless secs_held * (last - secs_held) > record

      acc + 1
    end
  end
  .inject(&:*)
end

test = [
  "Time:      7  15   30",
  "Distance:  9  40  200"
]

puts day6_part_one(test)

file = File.open("d6.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day6_part_one(file_data)
