#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day07.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).first.split(',').map(&:to_i)

ap input

def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

best_pos = median(input)
distance = input.map { |current_pos| (current_pos - best_pos).abs }.inject(&:+).to_i

puts distance
