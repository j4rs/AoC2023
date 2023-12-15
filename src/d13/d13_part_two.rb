# frozen_string_literal: true

def find_mirror(grid)
  # Got the solution from here https://www.youtube.com/watch?v=GYbjIvTQ_HA
  (1...grid.length).each do |i|
    above = grid[...i].reverse # above the line
    below = grid[i..] # below the line

    # Find the number of differences between the two rows
    # If there is only one difference, this is the new mirror line
    diff = above.zip(below).sum do |(a, b)|
      next 0 if b.nil?

      a.chars.zip(b.chars).sum { |c, d| c == d ? 0 : 1 }
    end

    return i if diff == 1
  end
  0
end

def day13_part_two(input)
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

pp day13_part_two(test)

# Large puzzle input
file = File.open("d13.txt")
file_data =
  file
    .read
    .split(/\n\n/)
    .map(&:split)

file.close

pp day13_part_two(file_data)
