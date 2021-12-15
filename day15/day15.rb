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

  private

  def dijkstra(x, y, target:)
    loop do
      puts "dijkstra at #{x} #{y} with risk #{@cells[[x, y]][:lowest_risk]}"
      return @cells[[x, y]][:lowest_risk] if x == target[:x] && y == target[:y]

      neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
                    .map { |modifier| [x + modifier[0], y + modifier[1]] }
                    .reject { |neighbor| neighbor[0] < 0 || neighbor[0] >= @width || neighbor[1] < 0 || neighbor[1] >= @height }
                    .reject { |neighbor| @cells[[neighbor[0], neighbor[1]]][:computed] }

      neighbors.each do |neighbor|
        new_risk = @cells[[x, y]][:lowest_risk] + @cells[[neighbor[0], neighbor[1]]][:risk]
        @cells[[neighbor[0], neighbor[1]]][:lowest_risk] = new_risk if new_risk <= @cells[[neighbor[0], neighbor[1]]][:lowest_risk] || @cells[[neighbor[0], neighbor[1]]][:lowest_risk] == 0
      end

      @cells[[x, y]][:computed] = true
      x, y = @cells.reject { |cell| @cells[cell][:computed] || @cells[cell][:lowest_risk].zero? }.min_by { |_, cell| cell[:lowest_risk] }[0]
    end
  end
end

map = Map.new

input.each { |row| map.feed(row.split('').map(&:to_i)) }

ap map.lower_risk_to(map.width - 1, map.height - 1)
