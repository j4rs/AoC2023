# frozen_string_literal: true

def day8_part_one(input)
  # Parse the data
  instructions = input[0].scan(/L|R/)
  map =
    input[2..]
      .each_with_object({}) do |line, hash|
        entry = line.scan(/(\S{3}) = \((\S{3}), (\S{3})\)/).flatten
        hash[entry[0]] = entry[1..]
        hash
      end

  # Initialize counters and position
  position = "AAA"
  steps = 0

  instructions.cycle do |instruction|
    # Find next move and position
    inst_index = instruction == "L" ? 0 : 1 # is L or R
    position = map.fetch(position)[inst_index] # find next node

    steps += 1
    break if position == "ZZZ"
  end

  steps
end

test = [
  "LLR",
  "",
  "AAA = (BBB, BBB)",
  "BBB = (AAA, ZZZ)",
  "ZZZ = (ZZZ, ZZZ)"
].freeze

puts day8_part_one(test)

file = File.open("d8.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day8_part_one(file_data)
