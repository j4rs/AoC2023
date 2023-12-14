# frozen_string_literal: true

def find_mirror(grid)
  (1...grid.length).each do |i|
    above = grid[...i].reverse # above the line
    below = grid[i..] # below the line

    # make above and below the same length
    above = above[...below.length]
    below = below[...above.length]

    return i if above == below
  end
  0
end

def day13_part_one(input)
  # input is an array of patterns
  input.map do |pattern|
    rows = find_mirror(pattern) * 100

    # flip the pattern and calculate the cols
    transpose_pattern =
      pattern
        .map(&:chars)
        .transpose
        .map(&:join)

    cols = find_mirror(transpose_pattern)
    rows + cols
  end
  .sum
end

test = <<~INPUT
  #.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.

  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
INPUT
  .split(/\n\n/)
  .map(&:split)

pp day13_part_one(test)

# Large puzzle input
file = File.open("d13.txt")
file_data =
  file
    .read
    .split(/\n\n/)
    .map(&:split)

file.close

pp day13_part_one(file_data)
