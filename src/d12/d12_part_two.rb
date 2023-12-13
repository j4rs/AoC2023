# frozen_string_literal: true

CACHE = {}

def count(config, nums)
  key = [config, nums]

  return nums.empty? ? 1 : 0 if config.nil? || config.empty?
  return config.include?("#") ? 0 : 1 if nums.empty?

  return CACHE[key] if CACHE.key?(key)

  result = 0

  result += count(config[1..], nums) if ".?".include?(config[0])

  if "#?".include?(config[0]) &&
     (nums[0] <= config.length && !config[...nums[0]].include?(".") &&
      (nums[0] == config.length || config[nums[0]] != "#"))
    result += count(config[nums[0] + 1..], nums[1..])
  end

  CACHE[key] = result

  result
end

def day12_part_two(input)
  input.map do |line|
    config, nums = line.split
    nums = nums.split(",").map(&:to_i)

    # Unfold the initial state
    config = ([config] * 5).join("?")
    nums *= 5

    count(config, nums)
  end
  .sum
end

test = <<~INPUT
  ???.### 1,1,3
  .??..??...?##. 1,1,3
  ?#?#?#?#?#?#?#? 1,3,1,6
  ????.#...#... 4,1,1
  ????.######..#####. 1,6,5
  ?###???????? 3,2,1
INPUT
  .split(/\n/)

pp day12_part_two(test)

# Large puzzle input
file = File.open("d12.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day12_part_two(file_data)
