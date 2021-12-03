#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require "awesome_print"

if ARGV.empty?
  warn 'Usage: ./day03.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).map(&:chop).map { |input| input.split("") }

gamma = (0..(input[0].size - 1)).map do |idx|
  ap "checking #{idx}"
  one = input.select { |mesurement| mesurement[idx].eql?("1") }.size
  zero = input.size - one
  ap "have #{one} ones and #{zero} zeros"

  one > zero ? "1" : "0"
end

ap gamma
epsilon = gamma.map { |gamma_bit| gamma_bit.eql?("0") ? "1" : "0" }.join
gamma = gamma.join

puts "Gama = #{gamma.to_i(2)}; Epsilon = #{epsilon.to_i(2)}; Consumption = #{gamma.to_i(2) * epsilon.to_i(2)}"
