# frozen_string_literal: true

def day11_part_two(input)
  gsymbol = "#"
  void = "."

  galaxies = []
  rows = input.length
  cols = input[0].length

  exp_factor = 1000000

  rows_without_galaxies =
    input
      .each_with_index
      .reduce([]) do |acc, (row, index)|
        next acc if row.include?(gsymbol)

        acc << index
    end

  cols_without_galaxies =
    cols.times.reduce([]) do |acc, col|
      has_galaxies = rows.times.any? do |row|
        input[row][col].include?(gsymbol)
      end

      next acc if has_galaxies

      acc << col
    end

  rows_without_galaxies =
    rows_without_galaxies
      .each_with_index
      .map do |row, index|
        rows_without_galaxies[index] = row + index * exp_factor
      end

  pp rows_without_galaxies
  pp cols_without_galaxies

  cols_without_galaxies =
    cols_without_galaxies
      .each_with_index
      .map do |col, index|
        cols_without_galaxies[index] = col + index * exp_factor
      end

  expand = input.dup
  rows_without_galaxies.each do |row|
    (row...row + exp_factor).each do |time|
      expand = expand[0...time] + [void * expand[0].length] + expand[time...]
    end
  end

  pp ".- rows -."
  pp expand

  cols_without_galaxies.each do |col|
    (col...col + exp_factor).each do |time|
      # 2, 6, 10
      expand.length.times.each do |row|
        expand[row] = expand[row][0...time] + "." + expand[row][time...]
      end
    end
  end

  pp cols_without_galaxies
  pp ".- cols -."
  pp expand
  pp ".---."

  expand.each_with_index do |drow, row|
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

  # pp pairs.length

  pairs.map do |pair|
    g1 = pair.first
    g2 = pair.last
    ["#{g1[0]}:#{g2[0]}", (g1[1] - g2[1]).abs + (g1[2] - g2[2]).abs]
  end
  .map(&:last)
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

puts day11_part_two(test)

file = File.open("d11.txt")
file_data = file.readlines.map(&:chomp)
file.close

# puts day11_part_two(file_data)
