# frozen_string_literal: true

def extrapolate(acc, history)
  acc << history
  return acc if history.all?(&:zero?)

  history =
    history
    .each_with_index
    .map do |value, index|
      next if index.zero?

      value - history[index - 1]
    end
    .compact

  extrapolate(acc, history) # use recursion till noall are zeroes
end

def add_placeholder(input, index)
  return input if index == input.length

  if index.zero?
    input[index] << input[index].last
  else
    input[index] << input[index].last + input[index - 1].last
  end

  add_placeholder(input, index + 1) # use recursion till reaching last array
end

def day9_part_one(input)
  # Parse the data
  input.map do |i|
    # Parse the input line
    history = i.scan(/(-?\d+)/).flatten.map(&:to_i)

    extra = extrapolate([], history) # extrapolate values
    add_placeholder(extra.reverse, 0) # add placeholders
  end
  .map(&:last) # histories
  .map(&:last) # placeholders
  .sum
end

test = [
  "0 3 6 9 12 15",
  "1 3 6 10 15 21",
  "10 13 16 21 30 45"
].freeze

pp day9_part_one(test)

file = File.open("d9.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day9_part_one(file_data)
