# frozen_string_literal: true

def day10_part_one(input)
  start = "S"
  north = :north
  south = :south
  east  = :east
  west  = :west

  matrix = [[]]

  pipes = {
    # north and south
    "|" => lambda { |from, row, col|
      inc = from == north ? 1 : -1
      [from, row + inc, col]
    },
    # east and west
    "-" => lambda { |from, row, col|
      inc = from == east ? 1 : -1
      [from, row, col + inc]
    },
    # north and east
    "L" => lambda { |from, row, col|
      vrow, vcol, to = from == north ? [0, 1, east] : [-1, 0, south]
      [to, row + vrow, col + vcol]
    },
    # north and west
    "J" => lambda { |from, row, col|
      vrow, vcol, to = from == north ? [0, -1, west] : [-1, 0, south]
      [to, row + vrow, col + vcol]
    },
    # south and east
    "F" => lambda { |from, row, col|
      vrow, vcol, to = from == south ? [0, 1, east] : [1, 0, north]
      [to, row + vrow, col + vcol]
    },
    # south and west
    "7" => lambda { |from, row, col|
      vrow, vcol, to = from == south ? [0, -1, west] : [1, 0, north]
      [to, row + vrow, col + vcol]
    }
  }

  matrix = input.reduce([]) { |acc, row| acc << row.chars }

  rows = matrix.length
  cols = matrix[0].length

  srow, scol = []
  (0..rows - 1).each do |row|
    (0..cols - 1).each do |col|
      next unless matrix[row][col] == start

      srow = row
      scol = col
      break
    end
  end

  # Find the loop
  direction, next_row, next_col =
    # north, south, east, west
    if srow.positive? && ["|", "F", "7"].include?(matrix[srow - 1][scol])
      [:south, srow - 1, scol] # north
    elsif srow < rows && ["|", "J", "L"].include?(matrix[srow + 1][scol])
      [:north, srow + 1, scol] # south
    elsif scol < cols && ["-", "J", "7"].include?(matrix[srow][scol + 1])
      [:west, srow, scol + 1] # east (scol + 1)
    elsif ["-", "F", "L"].include?(matrix[srow][scol - 1])
      [:east, srow, scol - 1] # west (scol + 1)
    else
      raise "No starting destination found"
    end

  start_tile = matrix[next_row][next_col] # -, |, L, 7, ...
  direction, next_row, next_col = pipes[start_tile].call(direction, srow, scol) # next tile based on current one

  steps = 1
  next_tile = matrix[next_row][next_col]

  until next_tile == start
    # Find new direction and tile
    direction, next_row, next_col = pipes[next_tile].call(direction, next_row, next_col)
    next_tile = matrix[next_row][next_col]

    steps += 1
  end

  steps / 2
end

def go_to(fromx, fromy, direction, tile); end

test = [
  "7-F7-",
  ".FJ|7",
  "SJLL7",
  "|F--J",
  "LJ.LJ"
].freeze

pp day10_part_one(test)

file = File.open("d10.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day10_part_one(file_data)
