# frozen_string_literal: true

def count(config, nums)
  return nums.empty? ? 1 : 0 if config.nil? || config.empty?
  return config.include?("#") ? 0 : 1 if nums.empty?

  result = 0

  result += count(config[1..], nums) if ".?".include?(config[0])

  if "#?".include?(config[0]) &&
     (nums[0] <= config.length && !config[...nums[0]].include?(".") &&
      (nums[0] == config.length || config[nums[0]] != "#"))
    result += count(config[nums[0] + 1..], nums[1..])
  end

  result
end

def day12_part_one(input)
  input.map do |line|
    config, nums = line.split
    nums = nums.split(",").map(&:to_i)

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

pp day12_part_one(test)

# Large puzzle input
file = File.open("d12.txt")
file_data = file.readlines.map(&:chomp)
file.close

pp day12_part_one(file_data)
