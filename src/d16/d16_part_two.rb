# frozen_string_literal: true

POS = {
  right: [0, 1],
  left: [0, -1],
  up: [-1, 0],
  down: [1, 0]
}

def move_beam(grid, tiles, point, direction)
  unless (0...grid.length).include?(point[0]) &&
         (0...grid[0].length).include?(point[1])
    return # dead end
  end

  tile_key = point.map(&:to_s).join(",")
  return if tiles&.dig(tile_key, direction) # already energized

  # Energize the current tile
  tiles[tile_key] ||= {} # initialize it first time
  tiles[tile_key][direction] ||= 1

  # Calc next move
  next_right = point.zip(POS[:right]).map(&:sum)
  next_left = point.zip(POS[:left]).map(&:sum)
  next_up = point.zip(POS[:up]).map(&:sum)
  next_down = point.zip(POS[:down]).map(&:sum)
  next_same_dir = eval("next_#{direction.to_s}")

  # Shared params
  params = [grid, tiles]
  # What happens next

  tile_content = grid[point.first][point.last]
  case tile_content
  when "|"
    if [:right, :left].include?(direction)
      move_beam(*params, next_up, :up)
      move_beam(*params, next_down, :down)
    else
      move_beam(*params, next_same_dir, direction)
    end
  when "-"
    if [:up, :down].include?(direction)
      move_beam(*params, next_left, :left)
      move_beam(*params, next_right, :right)
    else
      move_beam(*params, next_same_dir, direction)
    end
  when "/"
    move_beam(*params, next_up, :up) if direction == :right
    move_beam(*params, next_down, :down) if direction == :left
    move_beam(*params, next_right, :right) if direction == :up
    move_beam(*params, next_left, :left) if direction == :down
  when "\\"
    move_beam(*params, next_down, :down) if direction == :right
    move_beam(*params, next_up, :up) if direction == :left
    move_beam(*params, next_left, :left) if direction == :up
    move_beam(*params, next_right, :right) if direction == :down
  else
    move_beam(*params, next_same_dir, direction) # "."
  end
end

def day16_part_two(input)
  rows = input.length
  cols = input[0].length
  grid = input

  # Brute force
  columns = %i(down left up right).map do |direction|
    coords =
      case direction
      when :down
        (1...cols).map { |col| [0, col] } # top column
      when :left
        (1...rows).map { |row| [row, cols - 1] } # right column
      when :up
        (1...cols).map { |col| [rows - 1, col] } # lower column
      when :right
        (1...rows).map { |row| [row, 0] } # left column
      end

    coords.map do |point|
      tiles = {}
      move_beam(grid, tiles, point, direction)
      tiles.keys.count
    end
  end
  .flatten
  .max

  corners = [
    [0, 0],
    [0, cols - 1],
    [rows - 1, 0],
    [rows - 1, cols - 1]
  ]
  .each_with_index
  .map do |(row, col), index|
    directions =
      case index
      when 0
        [:right, :down]
      when 1
        [:down, :left]
      when 2
        [:right, :up]
      when 3
        [:up, :left]
      end
    directions.map do |direction|
      tiles = {}
      move_beam(grid, tiles, [row, col], direction)
      tiles.keys.count
    end
  end
  .flatten
  .max

  [columns, corners].max
end

test = <<~INPUT
  .|...\\....
  |.-.\\.....
  .....|-...
  ........|.
  ..........
  .........\\
  ..../.\\\\..
  .-.-/..|..
  .|....-|.\\
  ..//.|....
INPUT
  .split(/\n/)

pp day16_part_two(test)

# Large puzzle input
file = File.open("d16.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day16_part_two(file_data)
