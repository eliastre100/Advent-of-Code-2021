#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day07.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).first.split(',').map(&:to_i)

def median(array)
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

best_pos = median(input)
distance = input.map { |current_pos| (current_pos - best_pos).abs }.inject(&:+).to_i

puts "Step 1: #{best_pos} best pos cost #{distance}"

shortest = (input.min..input.max).map do |try_position|
  [try_position, input.map { |current_pos| (current_pos - try_position).round.abs.to_i.downto(0).sum }.compact.sum]
end.min_by { |try| try[1] }

best_pos = shortest[0]
distance = shortest[1]

puts "Step 2: #{best_pos} best pos cost #{distance}"
