# frozen_string_literal: true

def day2_part_two(input)
  min_cubes_powers = []

  input.each do |game|
    max_cubes = { "red" => 1, "green" => 1, "blue" => 1 }

    game
      .split(";")
      .each do |iteration|
        max_cubes.each do |color, max|
          reveladed_cubes = iteration.scan(/(\d+) #{color}/).flatten[0].to_i
          max_cubes[color] = reveladed_cubes if reveladed_cubes > max
        end
      end

    # Power of max
    min_cubes_powers << max_cubes.values.inject(:*)
  end

  min_cubes_powers.sum
end

test = <<~INPUT
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
INPUT
  .split(/\n/)

puts day2_part_two(test)

# Large puzzle input
file = File.open("d2.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day2_part_two(file_data)
