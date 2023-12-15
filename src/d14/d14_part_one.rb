# frozen_string_literal: true

def transpose(input)
  input.map(&:chars).transpose.map(&:join)
end

def tilt(input)
  input.map do |row|
    row
      .split(/(#)/)
      .map { |group| group.chars.sort.reverse }
      .join
  end
end

def day14_part_one(input)
  rows = input.length
  input = tilt(transpose(input))
  # Transpose it back and calc load
  transpose(input)
    .each_with_index
    .reduce(0) do |acc, (row, index)|
      acc + row.count("O") * (rows - index)
    end
end

test = <<~INPUT
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
INPUT
  .split(/\n/)

pp day14_part_one(test)

# Large puzzle input
file = File.open("d14.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day14_part_one(file_data)
