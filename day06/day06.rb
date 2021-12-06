#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day06.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).first.split(",").map(&:to_i)

(0..(80 - 1)).each do
  new = input.count(&:zero?)
  input = input.map { |value| value.zero? ? 6 : value - 1 }
  (0..(new - 1)).each { input << 8 }
end

puts input.count
