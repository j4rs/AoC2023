# frozen_string_literal: true

def day4_part_one(input)
  # Reduce the input to the total value of the cards
  input.reduce(0) do |total, card|
    numbers = card.gsub(/Card\s+\d+:\s+/, "").split("|")
    winners = numbers[0].scan(/\d{1,2}/) & numbers[1].scan(/\d{1,2}/)

    next total unless winners.any?

    card_value = winners[1..].reduce(1) { |acc| acc * 2 }
    total + card_value
  end
end

test = [
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
]

puts day4_part_one(test)

# Large puzzle input
file = File.open("day4.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day4_part_one(file_data)
