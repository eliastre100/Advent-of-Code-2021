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

class Polymer
  attr_accessor :groups_occurrence

  def initialize(definition)
    @definition = definition
    @groups_occurrence = {}
    definition.size.times do |idx|
      @groups_occurrence[definition[idx] + definition[idx + 1].to_s] = 1 + @groups_occurrence[definition[idx] + definition[idx + 1].to_s].to_i
    end
  end

  def transform(rules, iterations)
    occurrences = @groups_occurrence
    iterations.times do
      occurrences = occurrences.map do |group, occurrences|
        if rules[group]
          rules[group].map { |produce| [produce, occurrences] }
        else
          [[group, occurrences]]
        end
      end.flatten(1)
         .group_by { |group| group[0] }
         .transform_values { |occurences| occurences.sum { |occurrence| occurrence[1] }}
    end
    count_token_occurrence(occurrences)
  end

  def count_token_occurrence(group_occurrences)
    occurrence_map = group_occurrences.map do |group, occurrences|
      group.split('').map do |token|
        [token, occurrences]
      end
    end.flatten(1)
       .group_by { |occurrence_group| occurrence_group[0] }
       .map { |token, occurrences| [token, occurrences.sum { |occurrence| occurrence[1] }] }
       .to_h

    occurrence_map[@definition[0]] += 1
    occurrence_map.transform_values { |value| value / 2 }
  end
end

polymer = Polymer.new(input.first)

rules = input.drop(2).map do |rule|
  requires, produce = rule.split('->').map(&:strip)
  [requires, [requires[0] + produce, produce + requires[1]]]
end.to_h

polymer_state = polymer.transform(rules, 40)
min, max = polymer_state.map { |_, occurrences| occurrences }.minmax

ap max - min
