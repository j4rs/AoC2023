# frozen_string_literal: true

def day5_part_one(input)
  almanac = {}
  # Parse the input
  seeds =
    input[0]
      .scan(/seeds: (.*)/)
      .flatten[0]
      .split(" ")
      .map(&:to_i)

  map_type = ""
  input[1..]
    .each do |line|
      next if line.empty?

      if line.include?("map:")
        map_type = line.gsub(" map:", "")
        next
      end

      numbers = line.split(" ").map(&:to_i)
      almanac[map_type] ||= []
      almanac[map_type] << { dest: numbers[0], source: numbers[1], range: numbers[2] }
    end

  seeds.reduce(0) do |min_location, seed|
    # Reduce each seed to its location
    location =
      almanac.reduce(seed) do |source, (_, maps)|
        valid_maps = maps.reject do |m|
          m[:source] > source || (m[:source] + m[:range]) < source
        end

        next source if valid_maps.empty?

        entry =
          valid_maps.find do |m|
            (m[:source]...(m[:source] + m[:range])).include?(source)
          end

        next source unless entry # same destination as it is not mapped

        entry[:dest] + (1..(source - entry[:source])).size
      end

    min_location.zero? ? location : [min_location, location].min
  end
end

test = [
  "seeds: 79 14 55 13",
  "",
  "seed-to-soil map:",
  "50 98 2",
  "52 50 48",
  "",
  "soil-to-fertilizer map:",
  "0 15 37",
  "37 52 2",
  "39 0 15",
  "",
  "fertilizer-to-water map:",
  "49 53 8",
  "0 11 42",
  "42 0 7",
  "57 7 4",
  "",
  "water-to-light map:",
  "88 18 7",
  "18 25 70",
  "light-to-temperature map:",
  "45 77 23",
  "81 45 19",
  "68 64 13",
  "",
  "temperature-to-humidity map:",
  "0 69 1",
  "1 0 69",
  "",
  "humidity-to-location map:",
  "60 56 37",
  "56 93 4"
]

puts day5_part_one(test)

# Large puzzle input
file = File.open("d5.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day5_part_one(file_data)
