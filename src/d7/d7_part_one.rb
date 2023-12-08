# frozen_string_literal: true

def day7_part_one(input)
  # Map letters to its strength in number
  strengths = {
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "J" => 11,
    "T" => 10
  }

  # Parse the input
  hands = input.map(&:split)

  # Classify the hands in Five of a Kind, Four of a Kind, ...
  hands.each do |hand|
    cards = hand[0].chars.tally

    equal_cards, *rest = cards.sort_by { |_, v| -v }.map(&:last)
    hand_type =
      case equal_cards
      when 5
        50 # Five of a Kind
      when 4
        40 # Four of a kind
      when 3
        rest.include?(2) ? 35 : 30 # "Full house" or "Three of a kind"
      when 2
        rest.include?(2) ? 25 : 20 # "Two pair" or "One pair"
      else
        10 # "High card"
      end

    hand << hand_type
  end

  # Let's play the cards

  # First order by hand type desc and group them
  hands_group =
    hands
      .sort_by! { |_, _, type| -type }
      .group_by { |_, _, type| type }

  # Second order, pick winner for each hand on each group
  hands_group.each do |_, cards|
    cards.sort! do |(ca, _, _), (cb, _, _)|
      wins = 0
      # Compare card by card until found a winner, tie otherwise (wins is zero)
      5.times do |idx|
        next if ca[idx] == cb[idx]

        a = strengths.fetch(ca[idx], ca[idx]).to_i
        b = strengths.fetch(cb[idx], cb[idx]).to_i

        wins = a > b ? -1 : 1
        break
      end
      wins
    end
  end

  # Finally reverse the order (weakest to stronger) and return the sum of bid * rank
  hands_group
    .values
    .flatten(1)
    .reverse
    .each_with_index
    .map { |card, rank| card[1].to_i * (rank + 1) }
    .sum
end

test = [
  "32T3K 765",
  "T55J5 684",
  "KK677 28",
  "KTJJT 220",
  "QQQJA 483"
].freeze

puts day7_part_one(test)

file = File.open("d7.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day7_part_one(file_data)
