#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require "awesome_print"

if ARGV.empty?
  warn 'Usage: ./day03.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).map(&:chop).map { |input| input.split("") }

gamma = (0..(input[0].size - 1)).map do |idx|
  one = input.select { |mesurement| mesurement[idx].eql?("1") }.size
  zero = input.size - one

  one > zero ? "1" : "0"
end

epsilon = gamma.map { |gamma_bit| gamma_bit.eql?("0") ? "1" : "0" }.join
gamma = gamma.join

puts "Gama = #{gamma.to_i(2)}; Epsilon = #{epsilon.to_i(2)}; Consumption = #{gamma.to_i(2) * epsilon.to_i(2)}"

def search_presence(input, position, default: "1")
  one = input.map { |value| value[position] }.count("1")
  return default if one == input.size.to_f / 2

  one > (input.size.to_f / 2) ? "1" : "0"
end

def extract_from_value(input, position, inverse: false)
  search = search_presence(input, position)
  search = search.eql?("1") ? "0" : "1" if inverse

  elected = input.select { |value| value[position].eql?(search) }
  return elected.first if elected.size == 1

  extract_from_value(elected, position + 1, inverse: inverse)
end

oxygen = extract_from_value(input, 0).join
co2 = extract_from_value(input, 0, inverse: true).join

puts "Oxygen = #{oxygen.to_i(2)}; CO2 = #{co2.to_i(2)}; Answer = #{oxygen.to_i(2) * co2.to_i(2)}"
