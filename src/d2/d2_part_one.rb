# frozen_string_literal: true

def day2_part_one(input)
  cubes = { "red" => 12, "green" => 13, "blue" => 14 }
  valid_games = []

  input.each do |game|
    game_id = game.scan(/Game (\d+): /).flatten[0].to_i

    valid_game = true
    game.split(";").each do |iteration|
      cubes.each do |color, max_cubes|
        reveladed_cubes = iteration.scan(/(\d+) #{color}/).flatten[0].to_i
        # do not continue if reveladed cubes are bigger than top
        if reveladed_cubes > max_cubes
          valid_game = false
          break
        end
      end
    end
    # Valid game?
    valid_games << game_id if valid_game
  end

  valid_games.sum
end

test = [
  "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
]

puts day2_part_one(test)

# Large puzzle input
file = File.open("d2.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day2_part_one(file_data)
