# frozen_string_literal: true

def day15_part_two(input)
  boxes = {}
  input
    .split(",")
    .each do |str|
      operation = str.include?("-") ? "-" : "="
      label, lens = str.split(operation)

      box_num =
        label.chars.reduce(0) do |acc, char|
          (acc + char.ord) * 17 % 256
        end

      box = boxes[box_num]
      next if operation == "-" && box.nil?

      case operation
      when "-"
        l = box.find { |len| len.start_with?(label) }
        box.delete_at(box.index(l)) if l
      when "="
        lens = lens.to_i
        printed_label = "#{label} #{lens}"

        if box.nil?
          boxes[box_num] = [printed_label]
          next
        end

        l = box.find { |len| len.start_with?(label) }
        if l
          box[box.index(l)] = printed_label
        else
          box << printed_label
        end
      end
    end

  boxes
    .reject { |_, value| value.empty? }
    .map do |box, value|
      value
        .each_with_index
        .map do |len, index|
          (1 + box) * (index + 1) * len.split.last.to_i
        end
    end
    .flatten
    .sum
end

test = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
pp day15_part_two(test)

# Large puzzle input
file = File.open("d15.txt")
file_data = file.readline.gsub(/\n/, "")
file.close

pp day15_part_two(file_data)
