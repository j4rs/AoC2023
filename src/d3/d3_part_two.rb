# frozen_string_literal: true

def day3_part_two(input)
  cols = input[0].size
  rows = input.size
  gear_char = "*"
  adjacents = []

  matrix = input

  # Find adjacent numbers
  input
    # For each row (starting at 0)
    .each_with_index do |row, row_index|
      number = "" # initialize number
      # For each column (starting at 0)
      row.chars.each_with_index do |_, col_index|
        # Get char at [x,y]
        char = matrix[row_index][col_index]
        # Get next char [x, y + 1]
        next_char = col_index == cols - 1 ? nil : matrix[row_index][col_index + 1]
        # char is a number?
        if char.match?(/\d/)
          number += char

          # Ignore and continue if next char is a number
          # otherwise it means we have completed the number
          # and let check whether it is adjacent
          next if next_char&.match?(/\d/)

          # column where the number starts
          start_col = col_index - number.length + 1
          end_col   = col_index

          # left and right
          previous_char = start_col.positive? ? matrix[row_index][start_col - 1] : nil

          surrounding_chars = []

          surrounding_chars << [row_index, start_col - 1] if previous_char == gear_char
          surrounding_chars << [row_index, col_index + 1] if next_char == gear_char

          (start_col - 1..end_col + 1).each do |col|
            next if col.negative? || col > cols - 1
            next if row_index.negative? || row_index > rows - 1

            # Up
            if row_index.positive?
              char = matrix[row_index - 1][col]
              surrounding_chars << [row_index - 1, col] if char == gear_char
            end
            # Down
            if row_index < rows - 1
              char = matrix[row_index + 1][col]
              surrounding_chars << [row_index + 1, col] if char == gear_char
            end
          end

          is_adjacent = surrounding_chars.any?

          adjacents << [surrounding_chars.join(""), number] if is_adjacent
        else
          number = "" # and go to next char in the matrix
        end
      end
    end

  gear_ratios =
    adjacents
    .group_by(&:first) # Group by position of *
    .select { |_key, group| group.size == 2 } # Reject groups of 1 or more than two
    .values
    .reduce([]) do |acc, group| # power the found gears
      n1, n2 = group.map(&:last)
      acc << n1.to_i * n2.to_i
    end

  gear_ratios.sum
end

test = [
  "467..114..",
  "...*......",
  "..35..633.",
  "......#...",
  "617*......",
  ".....+.58.",
  "..592.....",
  "......755.",
  "...$.*....",
  ".664.598.."
]

puts day3_part_two(test)

# Large puzzle input
file = File.open("d4.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day3_part_two(file_data)
