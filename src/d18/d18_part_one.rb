# frozen_string_literal: true

def day18_part_one(input)
  grid = [[0, 0]]
  dirs = { "U": [-1, 0], "D": [1, 0], "L": [0, -1], "R": [0, 1] }

  num_of_vertexs = 0

  input.each do |line|
    dir, meters, _ = line.split(" ")

    drow, dcol = dirs[dir.to_sym]
    meters = meters.to_i

    num_of_vertexs += meters
    row, col = grid[-1]

    grid.append [row + drow * meters, col + dcol * meters]
  end

  shoelace_area =
    (1...grid.length).sum do |i|
      grid[i][0] * (grid[i - 1][1] - grid[(i + 1) % grid.length][1])
    end

  shoelace_area = shoelace_area.abs / 2

  interior = shoelace_area - num_of_vertexs / 2 + 1
  interior + num_of_vertexs
end

test = <<~INPUT
  R 6 (#70c710)
  D 5 (#0dc571)
  L 2 (#5713f0)
  D 2 (#d2c081)
  R 2 (#59c680)
  D 2 (#411b91)
  L 5 (#8ceee2)
  U 2 (#caa173)
  L 1 (#1b58a2)
  U 2 (#caa171)
  R 2 (#7807d2)
  U 3 (#a77fa3)
  L 2 (#015232)
  U 2 (#7a21e3)
INPUT
  .split(/\n/)

pp day18_part_one(test)

# Large puzzle input
file = File.open("d18.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day18_part_one(file_data)
