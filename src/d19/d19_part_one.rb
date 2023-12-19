# frozen_string_literal: true

def accept(workflow = $rules["in"], xmas)
  x, m, a, s = xmas

  # Find a rule that evaluates to true
  rule = workflow[:rules].find { |r| eval(r[0]) }
  resolution = rule ? rule[1] : workflow[:resol]

  # Recursion exit
  return true if resolution == "A"
  return false if resolution == "R"

  # Otherwise let's continue with the next workflow
  accept($rules[resolution], xmas)
end

def day19_part_one(input)
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

  input
    .last
    .split(/\n/)
    .map do |part|
      xmas =
        part
          .scan(/{([x,m,a,s]+\S*)}/)
          .flatten[0]
          .split(/,/)
          .map { |str| str.split("=").last.to_i }

      accept(xmas) ? xmas : 0
    end
    .flatten
    .sum
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

pp day19_part_one(test)

# Large puzzle input
file = File.open("d19.txt")
file_data = file.read.split(/\n\n/)
file.close

pp day19_part_one(file_data)
