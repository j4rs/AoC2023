# frozen_string_literal: true

require "algorithms"

def day17_part_one(input)
  # Parse input
  grid = input.map { |l| l.split("").map(&:to_i) }

  seen = Set.new
  pqueue = Containers::PriorityQueue.new { |a, b| (a <=> b) == -1 } # min has priority

  min_heat_loss = 0
  while min_heat_loss.zero?
    priority = pqueue.pop || [0, 0, 0, 0, 0, 0]

    heat_loss, row, col, drow, dcol, moves = priority

    # Destination reached
    if row == grid.length - 1 && col == grid[0].length - 1
      min_heat_loss = heat_loss
      break
    end

    # Skip if already seen
    next if seen.include?([row, col, drow, dcol, moves])

    seen << [row, col, drow, dcol, moves]

    # Move to next block
    if moves < 3 && [drow, dcol] != [0, 0]
      nrow = row + drow
      ncol = col + dcol

      if nrow >= 0 && nrow < grid.length && ncol >= 0 && ncol < grid[0].length
        new_heat_loss = heat_loss + grid[nrow][ncol]
        pqueue.push([new_heat_loss, nrow, ncol, drow, dcol, moves + 1], priority)
      end
    end

    # Move in all possible directions
    [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |ndrow, ndcol|
      next unless [ndrow, ndcol] != [drow, dcol] && [ndrow, ndcol] != [-drow, -dcol]

      nrow = row + ndrow
      ncol = col + ndcol

      if nrow >= 0 && nrow < grid.length && ncol >= 0 && ncol < grid[0].length
        new_heat_loss = heat_loss + grid[nrow][ncol]
        pqueue.push([new_heat_loss, nrow, ncol, ndrow, ndcol, 1], priority)
      end
    end
  end

  min_heat_loss
end

test = <<~INPUT
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
INPUT
  .split(/\n/)

pp day17_part_one(test)

# Large puzzle input
file = File.open("d17.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day17_part_one(file_data)
