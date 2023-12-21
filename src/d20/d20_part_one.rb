# frozen_string_literal: true

def day20_part_one(input)
  # Parse input
  panel =
    input
      .reduce({}) do |hash, line|
        left, right = line.split(" -> ").map(&:strip)
        name, type =
          case left[0]
          when "%"
            [left[1..], "%"]
          when "&"
            [left[1..], "&"]
          else
            [left, "broadcast"]
          end

        outputs = right.split(", ").map(&:strip)
        hash.merge(name => { type:, on: false, outputs:, lpulse: {} })
      end

  # Fill conjuntion modules memory
  panel
    .select { |_, v| v[:type] == "&" }
    .each do |mod_name, mod|
      panel
        .select { |_, v| v[:outputs].include?(mod_name) }
        .each_key { |k| mod[:lpulse][k] ||= :lo }
    end

  queue = Queue.new
  lo = hi = 0

  1000.times do
    lo += 1 # first signal to broadcaster

    panel["broadcaster"][:outputs].each do |mod_name|
      queue.push ["broadcast", mod_name, :lo]
    end

    until queue.empty?
      origin, target, pulse = queue.pop

      if pulse == :lo
        lo += 1
      else
        hi += 1
      end

      next unless panel.key?(target)

      mod = panel[target]

      if mod[:type] == "%"
        # Flip flop module
        next if pulse == :hi

        # Otherwise is lo, switch on/off
        mod[:on] = !mod[:on]
        mod[:outputs].each do |output|
          queue.push [target, output, mod[:on] ? :hi : :lo]
        end
      else
        # Conjuntion module
        mod[:lpulse][origin] = pulse
        all_hi = mod[:lpulse].values.all? { |v| v == :hi }

        mod[:outputs].each do |output|
          queue.push [target, output, all_hi ? :lo : :hi]
        end
      end
    end
  end

  lo * hi
end

test = <<~INPUT
  broadcaster -> a, b, c
  %a -> b
  %b -> c
  %c -> inv
  &inv -> a
INPUT
  .split(/\n/)

test2 = <<~INPUT
  broadcaster -> a
  %a -> inv, con
  &con -> output
  &inv -> b
  %b -> con
INPUT
  .split(/\n/)

pp day20_part_one(test2)

# Large puzzle input
file = File.open("d20.txt")
file_data = file.readlines(&:chomp)
file.close

pp day20_part_one(file_data)
