# frozen_string_literal: true

def day7_part_one(input)
  joker = "J"
  # Map letters to its strength in number
  strengths = {
    "A" => 14,
    "K" => 13,
    "Q" => 12,
    "T" => 11,
    joker => 1 # weakest individually
  }

  # Parse the input
  hands = input.map(&:split)

  # Classify the hands in Five of a Kind, Four of a Kind, ...
  hands.each do |hand|
    # hand can include one or more jokers
    cards =
      if hand[0].include?(joker) && hand[0] != joker * 5
        with_no_joker =
          hand[0]
            .chars
            .tally
            .except(joker)

        ordered_by_repeats = with_no_joker.sort_by { |_, r| -r } # sort by repeats

        max_number = with_no_joker.values.max # max number of cards that are no joker
        subst_card =
          case max_number
          when 4, 3
            ordered_by_repeats[0][0] # card that repeats 3 or 4 times
          when 2
            if ordered_by_repeats.map(&:last).uniq.size == 1
              ordered_by_repeats
                .map(&:first) # get the cards
                .max_by { |c| strengths.fetch(c, c).to_i } # with more value
            else
              ordered_by_repeats[0][0] # the card with more incidences
            end
          else
            with_no_joker
              .map(&:first) # get the cards
              .max_by { |c| strengths.fetch(c, c).to_i } # with more value
          end

        hand[0].gsub(joker, subst_card)
      else
        hand[0]
      end

    cards_tally = cards.chars.tally

    # Change them for the strongest card in the hand

    equal_cards, *rest = cards_tally.sort_by { |_, v| -v }.map(&:last)
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
    hand << cards
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
