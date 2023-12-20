# frozen_string_literal: true

def count(ranges, wfname = "in")
  # Recursion exit
  return 0 if wfname == "R"
  return ranges.values.reduce(1) { |acc, (lo, hi)| acc * (hi - lo + 1) } if wfname == "A"

  total = 0
  workflow = $rules[wfname]

  workflow[:rules].each do |r|
    key, comp, value = r[0].scan(/([x,m,a,s])([<,>])(.*)/).flatten # x, <, 2006
    value = value.to_i

    target = r[1] # coming resolution (next workflow name or A or R)
    lo, hi = ranges[key] # some values btw 1 and 4000

    if comp == "<"
      t = [lo, [value - 1, hi].min] # true side of the range
      f = [[value, lo].max, hi] # false side of the range
    else
      t = [[value + 1, lo].max, hi] # true side of the range
      f = [lo, [value, hi].min] # false side of the range
    end

    if t[0] <= t[1]
      range_dup = ranges.dup
      range_dup[key] = t
      total += count(range_dup, target)
    end
    break unless f[0] <= f[1]

    # Modify ranges for the coming rule
    ranges = ranges.dup
    ranges[key] = f
  end

  total + count(ranges, workflow[:resol])
end

# Found the solution for this part at https://www.youtube.com/watch?v=3RwIpUegdU4
# Repo: https://github.com/hyper-neutrino/advent-of-code/blob/main/2023/day19p2.py
def day19_part_two(input)
  # rules, workflows = input
  $rules =
    input
      .first
      .split(/\n/).reduce({}) do |acc, rule|
        name, rest = rule.scan(/(\S*){(\S+)}/).flatten

        rest = rest.split(/,/)
        rules = rest[...-1].map { |r| r.split(/:/) }

        resol = rest[-1]
        acc.merge(name => { rules: rules, resol: resol })
      end

  range = [1, 4000]
  xmas = "xmas".chars.reduce({}) { |acc, key| acc.merge(key => range) }

  count(xmas)
end

test = <<~INPUT
  px{a<2006:qkq,m>2090:A,rfg}
  pv{a>1716:R,A}
  lnx{m>1548:A,A}
  rfg{s<537:gd,x>2440:R,A}
  qs{s>3448:A,lnx}
  qkq{x<1416:A,crn}
  crn{x>2662:A,R}
  in{s<1351:px,qqz}
  qqz{s>2770:qs,m<1801:hdj,R}
  gd{a>3333:R,R}
  hdj{m>838:A,pv}

  {x=787,m=2655,a=1222,s=2876}
  {x=1679,m=44,a=2067,s=496}
  {x=2036,m=264,a=79,s=2244}
  {x=2461,m=1339,a=466,s=291}
  {x=2127,m=1623,a=2188,s=1013}
INPUT
  .split(/\n\n/)

pp day19_part_two(test)

# Large puzzle input
file = File.open("d19.txt")
file_data = file.read.split(/\n\n/)
file.close

pp day19_part_two(file_data)
