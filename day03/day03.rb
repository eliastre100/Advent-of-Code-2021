#!/usr/bin/env ruby

require_relative '../utils/input_reader'

if ARGV.empty?
  warn 'Usage: ./day03.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).map(&:chop).map { |input| input.split('') }

# Part 1
gamma = (0..(input[0].size - 1)).map do |idx|
  input.map { |value| value[idx] }
       .group_by { |value| value }
       .transform_values(&:size)
       .max_by { |value| value[1] }
       .first
end.join

epsilon = gamma.gsub(/./, '0' => '1', '1' => '0')

puts "Gama = #{gamma.to_i(2)}; Epsilon = #{epsilon.to_i(2)}; Consumption = #{gamma.to_i(2) * epsilon.to_i(2)}"

# Part 2
def get_most_present(input, position, default: '1')
  distribution = input.map { |value| value[position] }
                      .group_by { |value| value }
                      .transform_values(&:size)

  return default if distribution['1'] == distribution['0']

  distribution.max_by { |value| value[1] }.first
end

def extract_from_value(input, position, inverse: false)
  elected_token = get_most_present(input, position)
  elected_token = elected_token.eql?('1') ? '0' : '1' if inverse

  elected = input.select { |value| value[position].eql?(elected_token) }
  return elected.first if elected.one?

  extract_from_value(elected, position + 1, inverse: inverse)
end

oxygen = extract_from_value(input, 0).join
co2 = extract_from_value(input, 0, inverse: true).join

puts "Oxygen = #{oxygen.to_i(2)}; CO2 = #{co2.to_i(2)}; Answer = #{oxygen.to_i(2) * co2.to_i(2)}"
