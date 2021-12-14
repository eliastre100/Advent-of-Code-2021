#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day14.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

def positions_of(str, substr, hidden_size = 0, positions = [])
  position = str.index(substr)
  if position
    positions_of(str[position + 1..-1].to_s, substr, position + 1 + hidden_size, positions + [position + hidden_size])
  else
    positions
  end
end

template = input.first.split('')
rules = input.drop(2).map do |rule|
  requires, produce = rule.split('->').map(&:strip)
  [requires, produce]
end.to_h

10.times do
  insertions = rules.map do |requires, produce|
    positions_of(template.join, requires).map do |position|
      [position, produce]
    end
  end.reject { |insertion| insertion.empty? }
                    .flatten(1)
                    .sort_by { |insertion| insertion[0] }

  insertions.each.with_index do |insertion, idx|
    template.insert(insertion[0] + idx + 1, insertion[1])
  end
end

occurences =  template.group_by { |value| value }
                      .transform_values(&:count)
                      .to_h
                      .sort_by { |_, occurences| occurences }

ap occurences.last[1] - occurences.first[1]

# 0 1 2 3 4 5 6 7 8
# N B B B C N C C N BBNBNBBCHBHHBCHB
# NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
# NBBNBNBBCCNBCNCCNNBBNBBBNBBNBBBCBHBCBHHNHCBCBHB
