# frozen_string_literal: true

def pulse(intensity, source = "button", mod_name = "broadcaster")
  seen_key = [intensity, source, mod_name]
  return if $seen.include?(seen_key)

  $seen << seen_key

  puts "#{source} -#{intensity == :lo ? "low" : "high" } -> #{mod_name} "

  $pulses_count[intensity] += 1
end

def pulse(intensity, source = "button", mod_name = "broadcaster")
  seen_key = [intensity, source, mod_name]
  return if $seen.include?(seen_key)

  $seen << seen_key

  puts "#{source} -#{intensity == :lo ? "low" : "high" } -> #{mod_name} "

  $pulses_count[intensity] += 1
  mod = $panel[mod_name]

  return if mod.nil? # output

  case mod[:type]
  when "broadcast"
    mod[:modules].each { |name| pulse(intensity, mod_name, name) }
  when "flip"
    return if intensity == :hi
    # Otherwise is lo, switch on/off
    mod[:on] = !mod[:on]
    mod[:modules].each do |name|
      pulse(mod[:on] ? :hi : :lo, mod_name, name)
    end
  when "conj"
    mod[:lpulse] ||= {}
    mod[:lpulse][source] = intensity

    inputs =
      $panel
        .select { |_, v| v[:modules].include?(mod_name) }
        .keys
        .each { |k| mod[:lpulse][k] ||= :lo }

    all_hi = mod[:lpulse].values.all? { |v| v == :hi }

    mod[:modules].each do |name|
      pulse(all_hi ? :lo : :hi, mod_name, name)
    end
  end
end

def day20_part_one(input)
  $panel =
    input
      .reduce({}) do |hash, line|
        left, right = line.split("->").map(&:strip)
        name, type =
          case left[0]
          when "%"
            [left[1..], "flip"]
          when "&"
            [left[1..], "conj"]
          else
            [left, "broadcast"]
          end

        modules = right.split(", ").map(&:strip)
        hash.merge(name => { type:, on: false, modules: })
      end

  $panel
    .each do |mod_name, mod|

    end

  $pulses_count = { lo: 0, hi: 0 }

  pp $panel
  puts

  pushes = 3
  pushes.times do
    $seen = []
    pulse(:lo)
    puts
  end

  # pp $seen
  # pp $pulses_count
  $pulses_count.values.inject(:*)
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

# pp day20_part_one(file_data)
