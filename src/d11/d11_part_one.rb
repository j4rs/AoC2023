# frozen_string_literal: true

def day11_part_one(input)
  gsymbol = "#"
  void = "."

  galaxies = []
  rows = input.length
  cols = input[0].length

  rows_without_galaxies =
    input
      .each_with_index
      .reduce([]) do |acc, (row, index)|
        next acc if row.include?(gsymbol)

        acc << index
    end

  cols_without_galaxies =
    cols.times.reduce([]) do |acc, col|
      has_galaxies =
        rows.times.any? { |row| input[row][col].include?(gsymbol) }

      next acc if has_galaxies

      acc << col
    end

  input.each_with_index do |drow, row|
    drow
      .chars
      .each_with_index do |char, col|
        next unless char == "#"

        galaxies << [galaxies.length + 1, row, col]
      end
  end

  pairs = []

  (0...galaxies.length).each do |index|
    (index + 1...galaxies.length).each do |subindex|
      pairs << [galaxies[index], galaxies[subindex]]
    end
  end

  pairs.map do |pair|
    g1 = pair.first
    g2 = pair.last
    # Calc how many empty rows there are between them
    empty_rows_btw =
      rows_without_galaxies.reduce(0) do |acc, row|
        acc += 1 if row.between?([g1[1], g2[1]].min, [g1[1], g2[1]].max)
        acc
      end

    empty_cols_btw =
      cols_without_galaxies.reduce(0) do |acc, col|
        acc += 1 if col.between?([g1[2], g2[2]].min, [g1[2], g2[2]].max)
        acc
      end

    # calc cols
    rows_dist = (g1[1] - g2[1]).abs + empty_rows_btw
    cols_dist = (g1[2] - g2[2]).abs + empty_cols_btw

    rows_dist + cols_dist
  end
  .sum
end

test = <<~INPUT
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
INPUT
  .split(/\n/)

pp day11_part_one(test)

file = File.open("d11.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day11_part_one(file_data)
