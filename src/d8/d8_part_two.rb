# frozen_string_literal: true

def day8_part_two(input)
  # Parse the data
  instructions = input[0].scan(/L|R/)
  map =
    input[2..]
      .each_with_object({}) do |line, hash|
        entry = line.scan(/(\S{3}) = \((\S{3}), (\S{3})\)/).flatten
        hash[entry[0]] = entry[1..]
        hash
      end

  # Get the starting nodes
  start_nodes = map.keys.select { |node| node.end_with?("A") }
  # Each node has to traverse the map
  # returning their steps
  # then the response is the least common multiple of all the steps
  start_nodes.map do |node|
    steps = 0
    instructions.cycle do |instruction|
      # Find next move and position
      inst_index = instruction == "L" ? 0 : 1 # is L or R
      node = map.fetch(node)[inst_index] # find next node

      steps += 1
      break if node.end_with?("Z")
    end
    steps
  end
  .inject(:lcm)
end

test = [
  "LR",
  "",
  "11A = (11B, XXX)",
  "11B = (XXX, 11Z)",
  "11Z = (11B, XXX)",
  "22A = (22B, XXX)",
  "22B = (22C, 22C)",
  "22C = (22Z, 22Z)",
  "22Z = (22B, 22B)",
  "XXX = (XXX, XXX)"
].freeze

puts day8_part_two(test)

file = File.open("d8.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day8_part_two(file_data)
