# frozen_string_literal: true

def day15_part_one(input)
  input
    .split(",")
    .map do |str|
      str.chars.reduce(0) do |acc, char|
        (acc + char.ord) * 17 % 256
      end
    end
    .sum
end

test = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
pp day15_part_one(test)

# Large puzzle input
file = File.open("d15.txt")
file_data = file.readline.gsub(/\n/, "")
file.close

pp day15_part_one(file_data)
