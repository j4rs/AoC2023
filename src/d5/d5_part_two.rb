# frozen_string_literal: true

def day5_part_two(input, label = "test")
  started_at = Time.now
  # Parse input
  seeds =
    input[0]
      .scan(/seeds: (.*)/)
      .flatten[0]
      .split(" ")
      .map(&:to_i)

  map_type = ""
  almanac = {}
  # Populate the almanac
  input[1..]
    .each do |line|
      next if line.empty?

      if line.include?("map:")
        map_type = line.gsub(" map:", "")
        next
      end

      # Populate map
      numbers = line.split(" ").map(&:to_i)
      almanac[map_type] ||= []
      almanac[map_type] << { dest: numbers[0], source: numbers[1], range: numbers[2] }
    end

  # Initialize location to 0 and go up to max seed value (min seed + max range)
  # backwards in the map (from location up to seed) looking for the seed in the ranges
  # When found it that is the min location possible
  seeds_ranges = seeds.each_slice(2).to_a

  min_location = nil
  location = 0
  # From 0 and until we find
  until min_location
    seed = location # 0, 1, 2...
    # Travel the map backwards
    almanac.reverse_each do |_k, maps|
      # Look for destination in the source range
      map = maps.find { |m| (m[:dest]...(m[:dest] + m[:range])).include?(seed) }

      next unless map

      # If found it then get the new destination
      seed = map[:source] + (1..(seed - map[:dest])).size
    end

    # Look for final destination into seeds ranges
    # If found we finished with the minimum destination (location)
    found_seed = seeds_ranges.find do |range|
      (range[0]...(range[0] + range[1])).include?(seed)
    end

    min_location = location if found_seed
    location += 1
  end

  pp "Solution for #{label.capitalize} took #{Time.now - started_at} seconds"
  min_location
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

puts day5_part_two(test, "test")

# Large puzzle input
file = File.open("d5.txt")
file_data = file.readlines.map(&:chomp)
file.close

puts day5_part_two(file_data, "prod")
