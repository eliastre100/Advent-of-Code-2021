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

biggest_hop = target_area[1].min.abs
highest_point = (0..biggest_hop - 1).sum

ap highest_point

def step_falls(fall_required)
  @step_falls ||= [0]

  current_step = @step_falls.size
  while @step_falls[-1] < fall_required
    @step_falls << @step_falls[-1] + current_step
    current_step += 1
  end
  @step_falls
end

def velocity_steps(target)
  @step_velocity ||= [0]

  current_step = @step_velocity.size
  while @step_velocity[-1] < target
    @step_velocity << @step_velocity[-1] + current_step
    current_step += 1
  end
  @step_velocity
end

def hits?(position, velocity, target)
  return false if position[:x] > target[:x].max || position[:y] < target[:y].min
  return true if target[:x].include?(position[:x]) && target[:y].include?(position[:y])

  next_position = {
    x: position[:x] + velocity[:x],
    y: position[:y] + velocity[:y]
  }
  next_velocity = {
    x: [velocity[:x] - 1, 0].max,
    y: velocity[:y] - 1
  }
  hits?(next_position, next_velocity, target)
end

maximum_y_velocity = step_falls(highest_point).size - 1
minimum_y_velocity = target_area[1].min
maximum_x_velocity = target_area[0].max
minimum_x_velocity = velocity_steps(target_area[0].min).size - 1

target_area = {
  x: target_area[0].min..target_area[0].max,
  y: target_area[1].min..target_area[1].max
}

valid_velocities = (minimum_y_velocity..maximum_y_velocity).map do |y|
  (minimum_x_velocity..maximum_x_velocity).map do |x|
    hits?({x: 0, y: 0}, { x: x, y: y }, target_area)
  end.count(true)
end.sum

ap valid_velocities
# 65
