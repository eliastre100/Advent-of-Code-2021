#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day05.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class Map
  def initialize
    @vents = []
    @vents_positions = []
  end

  def add_vent_vector(vector)
    @vents << vector
    if vector[:start][:y] == vector[:end][:y]
      boundaries = [vector[:start][:x], vector[:end][:x]]
      (boundaries.min..boundaries.max).each do |x|
        add_vent_possition({ x: x, y: vector[:start][:y] })
      end
    elsif vector[:start][:x] == vector[:end][:x]
      boundaries = [vector[:start][:y], vector[:end][:y]]
      (boundaries.min..boundaries.max).each do |y|
        add_vent_possition({ x: vector[:start][:x], y: y })
      end
    else
      (vector[:start][:x]..vector[:end][:x]).each.with_index do |x, idx|
        direction = (vector[:end][:y] - vector[:start][:y]) / (vector[:end][:y] - vector[:start][:y]).abs
        add_vent_possition({ x: x, y: vector[:start][:y] + idx * direction })
      end

      (vector[:end][:x]..vector[:start][:x]).each.with_index do |x, idx|
        direction = (vector[:start][:y] - vector[:end][:y]) / (vector[:start][:y] - vector[:end][:y]).abs
        add_vent_possition({ x: x, y: vector[:end][:y] + idx * direction })
      end
    end
  end

  def count
    @vents_positions.flatten.compact.count { |value| value >= 2 }
  end

  def to_s
    @vents_positions.each.with_index do |row, idx|
      if row.nil?
        puts "..."
      else
        puts row.map { |value| value.nil? ? '.' : value.to_s }.join
      end
    end
  end

  def inspect
    ap @vents_positions
  end

  private

  def add_vent_possition(position)
    @vents_positions[position[:x]] ||= []
    @vents_positions[position[:x]][position[:y]] ||= 0
    @vents_positions[position[:x]][position[:y]] += 1
  end
end

map = Map.new

input.each do |line|
  points = line.split(' -> ').map do |vectors|
    vectors.split(',').map(&:to_i)
  end.map { |point| { x: point.last, y: point.first } }

  map.add_vent_vector({ start: points.first, end: points.last })
end


#map.add_vent_vector({ start: { x: 0, y: 9}, end: { x: 5, y: 9 }})

ap map.count
