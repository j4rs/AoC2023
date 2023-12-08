# frozen_string_literal: true

def day3_part_one(input)
  cols = input[0].size
  rows = input.size
  period = "."
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
          # so let check whether it is adjacent
          next if next_char&.match?(/\d/)

          # column where the number starts
          start_col = col_index - number.length + 1
          end_col   = col_index

          # left and right
          previous_char = start_col.positive? ? matrix[row_index][start_col - 1] : nil

          # Get the surrounding chars
          surrounding_chars = [previous_char, next_char].compact
          (start_col - 1..end_col + 1).each do |col|
            next if col.negative? || col > cols - 1
            next if row_index.negative? || row_index > rows - 1

            # Up
            surrounding_chars << matrix[row_index - 1][col] if row_index.positive?
            # Down
            surrounding_chars << matrix[row_index + 1][col] if row_index < rows - 1
          end

          # It is adjacent if any of the surrounding chars is a
          # symbol (not period, not a number)
          is_adjacent =
            surrounding_chars.any? do |char|
              char != period && !char.match?(/\d/)
            end

          adjacents << number if is_adjacent
        else
          number = "" # and go to next char in the matrix
        end
      end
    end

  adjacents.map(&:to_i).sum
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

puts day3_part_one(test)

# Large puzzle input
file = File.open("d3.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day3_part_one(file_data)
