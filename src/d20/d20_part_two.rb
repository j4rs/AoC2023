# frozen_string_literal: true

def day20_part_two(input)
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

  feed, = panel.select { |_, v| v[:outputs].include?("rx") }.keys
  seen =
    panel
      .select { |_, v| v[:outputs].include?(feed) }
      .keys.reduce({}) { |hash, k| hash.merge(k => 0) }

  cycle_lengths = {}

  queue = Queue.new
  presses = 0
  continue = true

  # Found the answer here https://www.youtube.com/watch?v=lxm6i21O83k
  # Again LCM this time making lot of assumption about the input data
  # Repo: https://github.com/hyper-neutrino/advent-of-code/blob/main/2023/day20p2.py
  while continue
    presses += 1 # first signal to broadcaster

    panel["broadcaster"][:outputs].each do |mod_name|
      queue.push ["broadcast", mod_name, :lo]
    end

    until queue.empty?
      origin, target, pulse = queue.pop
      next unless panel.key?(target)

      # LCM logic
      if target == feed && pulse == :hi
        seen[origin] += 1

        if cycle_lengths.key?(origin)
          raise unless presses == seen[origin] * cycle_lengths[origin]
        else
          cycle_lengths[origin] = presses
        end

        if seen.values.all?(&:positive?)
          presses = cycle_lengths.values.inject(:lcm)
          continue = false
        end
      end

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

  presses
end

# Large puzzle input
file = File.open("d20.txt")
file_data = file.readlines(&:chomp)
file.close

pp day20_part_two(file_data)
