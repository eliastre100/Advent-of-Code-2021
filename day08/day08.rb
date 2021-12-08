#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day07.rb [input file]'
  exit 1
end

sum = InputReader.read_string(ARGV[0]).map do |input|
  input.split("|").last.split(" ").map { |value| value.size }.select { |value| [2, 3, 4, 7].include?(value) }.count
end.sum

ap sum
