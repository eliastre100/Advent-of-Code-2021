#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day09.rb [input file]'
  exit 1
end

class Cave
  class Bassin
    def initialize(lowest_point, cave)
      @points = {}
      @cave = cave
      increase_size_from(lowest_point)
    end

    def size
      @points.size
    end

    private

    def increase_size_from(position)
      position_value = @cave.value_at(position[0], position[1])
      return if position_value >= 9

      @points[position] = true
      [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |modifier|
        next if @points[[position[0] + modifier[0], position[1] + modifier[1]]]
        neighbour_value = @cave.value_at(position[0] + modifier[0], position[1] + modifier[1])

        next if neighbour_value.nil? || position_value > neighbour_value

        increase_size_from([position[0] + modifier[0], position[1] + modifier[1]])
      end
    end
  end

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
    end
  end

  def bassins
    low_points.map do |starting_point, _|
      Bassin.new(starting_point, self)
    end
  end

  def value_at(y, x)
    return 100 if x < 0 || x >= @width || y < 0 || y >= @height

    @points[[y, x]]
  end
end

cave = Cave.new
InputReader.read_string(ARGV[0]).each { |row| cave.feed(row) }

low_points = cave.low_points.values

ap low_points.sum +  low_points.size

bassins = cave.bassins

bassins_sizes = bassins.map { |bassin| bassin.size }
ap bassins_sizes.max(3).inject(&:*)
