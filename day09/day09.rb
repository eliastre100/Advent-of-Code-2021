#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day09.rb [input file]'
  exit 1
end

class Cave
  def initialize
    @width = 0
    @height = 0
    @points = {}
  end

  def feed(row)
    row.split('').map(&:to_i).each.with_index do |point, x|
      @points[[@height, x]] = point
    end
    @width = row.size > @width ? row.size : @width
    @height += 1
  end

  def low_points
    @points.select do |corrdinates, value|
      neigbouhrs = [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |modifier|
        value_at(corrdinates[0] + modifier[0], corrdinates[1] + modifier[1])
      end

      neigbouhrs.min > value
    end.values
  end

  private

  def value_at(y, x)
    return 100 if x < 0 || x >= @width || y < 0 || y >= @height

    @points[[y, x]]
  end
end

cave = Cave.new
InputReader.read_string(ARGV[0]).each { |row| cave.feed(row) }

low_points = cave.low_points

ap low_points.sum +  low_points.size
