# frozen_string_literal: true

POS = {
  right: [0, 1],
  left: [0, -1],
  up: [-1, 0],
  down: [1, 0]
}

def move_beam(point, direction)
  unless (0...$grid.length).include?(point[0]) &&
         (0...$grid[0].length).include?(point[1])
    return # dead end
  end

  tile_key = point.map(&:to_s).join(",")
  return if $tiles&.dig(tile_key, direction) # already energized

  # Energize the current tile
  $tiles[tile_key] ||= {} # initialize it first time
  $tiles[tile_key][direction] ||= 1

  # Calc next move
  next_right = point.zip(POS[:right]).map(&:sum)
  next_left = point.zip(POS[:left]).map(&:sum)
  next_up = point.zip(POS[:up]).map(&:sum)
  next_down = point.zip(POS[:down]).map(&:sum)
  next_same_dir = eval("next_#{direction.to_s}")

  # What happens next
  tile_content = $grid[point.first][point.last]
  case tile_content
  when "|"
    if [:right, :left].include?(direction)
      move_beam(next_up, :up)
      move_beam(next_down, :down)
    else
      move_beam(next_same_dir, direction)
    end
  when "-"
    if [:up, :down].include?(direction)
      move_beam(next_left, :left)
      move_beam(next_right, :right)
    else
      move_beam(next_same_dir, direction)
    end
  when "/"
    move_beam(next_up, :up) if direction == :right
    move_beam(next_down, :down) if direction == :left
    move_beam(next_right, :right) if direction == :up
    move_beam(next_left, :left) if direction == :down
  when "\\"
    move_beam(next_down, :down) if direction == :right
    move_beam(next_up, :up) if direction == :left
    move_beam(next_left, :left) if direction == :up
    move_beam(next_right, :right) if direction == :down
  else
    move_beam(next_same_dir, direction) # "."
  end
end

def day16_part_one(input)
  rows = input.length
  cols = input[0].length
  $grid = input

  $tiles = {}
  move_beam([0, 0], :right)

  $tiles.keys.count
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

pp day16_part_one(test)

# Large puzzle input
file = File.open("d16.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day16_part_one(file_data)
