# frozen_string_literal: true

def day4_part_two(input)
  cards = {}

  input.each do |card|
    # Get card number
    card_number = card.scan(/Card\s+(\d+):/).flatten.first
    cards[card_number] ||= 0 # initialize card
    cards[card_number] += 1 # add orginal instance as copy

    # Check the card
    numbers = card.gsub(/Card\s+\d+:\s+/, "").split("|")
    winners = numbers[0].scan(/\d{1,2}/) & numbers[1].scan(/\d{1,2}/)

    # For each copy of the card
    cards[card_number].times do
      (1..winners.length).each do |n|
        number = (card_number.to_i + n).to_s
        cards[number] ||= 0
        cards[number] += 1
      end
    end
  end

  cards.values.sum
end

test = [
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
]

puts day4_part_two(test)

# Large puzzle input
file = File.open("d4.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day4_part_two(file_data)
