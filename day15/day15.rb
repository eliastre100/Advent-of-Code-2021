#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day14.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class Map
  attr_accessor :width, :height

  def initialize
    @cells = {}
    @edges = []
    @width = 0
    @height = 0
  end

  def feed(row)
    row.each.with_index do |risk, x|
      @cells[[x, @height]] = { risk: risk, lowest_risk: 0, computed: false }
    end
    @height += 1
    @width = row.size
  end

  def lower_risk_to(x, y)
    return @cells[[x, y]][:lowest_risk] if @cells[[x, y]][:lowest_risk] != 0

    dijkstra(0, 0, target: { x: x, y: y })
    @cells[[x, y]][:lowest_risk]
  end

  def grow(times)
    grow_horizontal times
    grow_vertical times
  end

  private

  def dijkstra(x, y, target:)
    edges = []

    loop do
      #puts "dijkstra at #{x} #{y} with risk #{@cells[[x, y]][:lowest_risk]}"
      return @cells[[x, y]][:lowest_risk] if x == target[:x] && y == target[:y]

      neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
                    .map { |modifier| [x + modifier[0], y + modifier[1]] }
                    .reject { |neighbor| (neighbor[0]).negative? || neighbor[0] >= @width || (neighbor[1]).negative? || neighbor[1] >= @height }
                    .reject { |neighbor| @cells[[neighbor[0], neighbor[1]]][:computed] }

      neighbors.each do |neighbor|
        new_risk = @cells[[x, y]][:lowest_risk] + @cells[[neighbor[0], neighbor[1]]][:risk]
        @cells[[neighbor[0], neighbor[1]]][:lowest_risk] = new_risk if new_risk <= @cells[[neighbor[0], neighbor[1]]][:lowest_risk] || (@cells[[neighbor[0], neighbor[1]]][:lowest_risk]).zero?
        edges << [neighbor[0], neighbor[1]] unless @cells[[neighbor[0], neighbor[1]]][:computed] # TODO: Use Heap instead of list
      end

      @cells[[x, y]][:computed] = true
      edges.uniq!
      edges.delete([x, y])

      x, y = edges.min_by { |position| @cells[position][:lowest_risk] }
    end
  end

  def grow_horizontal(times)
    (0..@height - 1).each do |y|
      (@width..@width * times).each do |x|
        recurrence = x / @width
        @cells[[x, y]] = @cells[[x % @width, y]].dup
        @cells[[x, y]][:risk] += recurrence
        @cells[[x, y]][:risk] -= 9 if @cells[[x, y]][:risk] > 9
      end
    end

    @width *= times
  end

  def grow_vertical(times)
    (@height..@height * times).each do |y|
      (0..@width - 1).each do |x|
        recurrence = y / @height
        @cells[[x, y]] = @cells[[x, y % @height]].dup
        @cells[[x, y]][:risk] += recurrence
        @cells[[x, y]][:risk] -= 9 if @cells[[x, y]][:risk] > 9
      end
    end

    @height *= times
  end
end

map = Map.new
input.each { |row| map.feed(row.split('').map(&:to_i)) }
map.grow(5)


ap map.width
ap map.height
ap map.lower_risk_to(map.width - 1, map.height - 1)
