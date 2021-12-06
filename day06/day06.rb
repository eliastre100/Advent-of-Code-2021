#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day06.rb [input file]'
  exit 1
end

states = InputReader.read_string(ARGV[0]).first
                    .split(',')
                    .map(&:to_i)
                    .group_by { |value| value }
                    .transform_values(&:count)

(0..(256 - 1)).each do
  new = states[0]
  states.transform_keys! { |remaining_days| remaining_days - 1 }
  states[6] = (states[6] || 0) + states[-1] unless states[-1].nil?
  states[8] = new
  states.delete(-1)
end

puts states.values.flatten.compact.inject(&:+)

=begin
#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day06.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0]).first.split(",").map(&:to_i)

REPRODUCTION_DELAY = 7
MATURATION_DELAY   = 2

def compute_child(day_to_first, current_day, target_day)
  current_day += day_to_first
  return 0 if current_day >= target_day

  remaining_days = target_day - current_day
  child_number = remaining_days / REPRODUCTION_DELAY + 1
  first_child_decent = compute_child(REPRODUCTION_DELAY + MATURATION_DELAY, current_day, target_day)

  puts "have #{child_number} with first doing #{first_child_decent}"

  descent = (0..(child_number - 1)).map do |child|
    first_child_decent - child
  end.reject(&:negative?).inject(&:+) + child_number

  descent || 0
end


result = input.map do |root|
  puts "Doing #{root}"
  compute_child(root + 1, 0, 80) + 1 # child + self
end

puts result.inject(&:+)
=end
