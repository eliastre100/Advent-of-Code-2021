#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day12.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class Map
  attr_reader :caves

  class Cave
    attr_reader :name, :links

    def initialize(name, map)
      @name = name
      @map = map
      @links = []
    end

    def link_to(cave)
      @links << cave
    end

    def major?
      @major ||= @name.upcase == @name
    end

    def routes_to(end_cave, visited_caves = [], minor_joker: false)
      if @name.eql?(end_cave)
        return (visited_caves + [@name]).join(',')
      end

      eligable_next_caves = @links.select do |intermediate_cave|
        intermediate_cave.major? ||
          (minor_joker && !%w[start end].include?(intermediate_cave.name)) ||
          !visited_caves.include?(intermediate_cave.name)
      end

      eligable_next_caves.map do |intermediate_cave|
        consume_joker = minor_joker && visited_caves.include?(intermediate_cave.name) && !intermediate_cave.major?
        intermediate_joker = consume_joker ? false : minor_joker
        intermediate_cave.routes_to(end_cave, visited_caves + [@name], minor_joker: intermediate_joker)
      end.flatten
    end
  end

  def initialize
    @caves = {}
  end

  def add_path(route_start, route_end)
    route_start_cave = cave_named(route_start)
    route_end_cave = cave_named(route_end)
    route_start_cave.link_to(route_end_cave)
    route_end_cave.link_to(route_start_cave)
  end

  def cave_named(name)
    @caves[name] ||= Cave.new(name, self)
  end
end

map = Map.new

input.each do |route|
  route_start, route_end = route.split('-')
  map.add_path(route_start, route_end)
end

ap (map.cave_named('start').routes_to('end').count)
ap (map.cave_named('start').routes_to('end', minor_joker: true).count)
