#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day17.rb [input file]'
  exit 1
end

target_area = InputReader.read_string(ARGV[0])[0].delete_prefix('target area: ')
                                                 .split(',')
                                                 .map { |part| part.split('=')[1].split('..').map(&:to_i) }

def step_falls(fall_required)
  @step_falls ||= [0]

  current_step = @step_falls.size
  while @step_falls[-1] <= fall_required
    @step_falls << @step_falls[-1] + current_step
    current_step += 1
  end
  @step_falls
end

def higher_y_velocity(y_velocity, target)
  highest_point = (0..y_velocity).sum
  min_fall, max_fall = (target.max - highest_point).abs, (target.min - highest_point).abs

  falls = step_falls(max_fall)

  if falls.detect { |fall| fall >= min_fall && fall <= max_fall }
    puts "HITS ! "
    #higher_y_velocity(y_velocity + 1, target)
  else
    y_velocity - 1
  end
end

=begin
y_velocity = higher_y_velocity(0, target_area[1])
answer = (0..y_velocity).sum

ap y_velocity
ap answer
=end

biggest_hop = target_area[1].min.abs
highest_point = (0..biggest_hop - 1).sum

ap highest_point

# 65
