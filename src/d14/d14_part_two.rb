# frozen_string_literal: true

def transpose(input)
  input.map(&:chars).transpose.map(&:join)
end

def tilt(input, asc = 1)
  input.map do |row|
    row
      .split(/(#)/)
      .map do |group|
        group.chars.sort { |char| char == "." ? asc : -asc }
      end
      .join
  end
end

def cycle(input)
  # north
  input = tilt(transpose(input))
  # west
  input = tilt(transpose(input))
  # south - # transpose back and tilt it in the other direction
  input = tilt(transpose(input), -1)
  # east
  tilt(transpose(input), -1)
end

def day14_part_two(input)
  rows = input.length

  grids = []

  # Found the solution here https://www.youtube.com/watch?v=WCVOBKUNc38
  # Count cycles and find the first duplicate
  until grids.include?(input)
    grids << input
    input = cycle(input) # run a cycle
  end

  iterations = grids.length
  first_dup = grids.index(input)

  grid = grids[(1_000_000_000 - first_dup) % (iterations - first_dup) + first_dup]

  # Calc load
  grid
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

pp day14_part_two(test)

# Large puzzle input
file = File.open("d14.txt")
file_data =
  file
    .read
    .split(/\n/)

file.close

pp day14_part_two(file_data)
