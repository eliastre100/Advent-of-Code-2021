#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day13.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class TransparentPaper
  def initialize
    @dots = []
    @height = 0
    @width = 0
  end

  def add_dot(x, y)
    @dots[y] ||= []
    @dots[y][x] = true
    @height = y if y > @height
    @width = x if x > @width
  end

  def horizontal_fold(position)
    (0..@height).each do |y|
      (position + 1..@width).each.with_index do |x, displacement|
        @dots[y] ||= []
        @dots[y][position - displacement - 1] ||= @dots.dig(y, x)
      end
    end
    @width = position - 1
  end
  
  def vertical_fold(position)
    (position + 1..@height).each.with_index do |y, displacement|
      (0..@width).each do |x|
        @dots[position - displacement - 1] ||= []
        @dots[position - displacement - 1][x] ||= @dots.dig(y, x)
      end
    end
    @height = position - 1
  end
  
  def count_points
    (0..@height).map do |y|
      (0..@width).count { |x| @dots[y][x] }
    end.sum
  end

  def to_s
    (0..@height).map do |y|
      (0..@width).map do |x|
        @dots.dig(y, x) ? '#' : '.'
      end.join
    end.join("\n") + "\nwidth => #{@width}; height => #{@height}"
  end
end

paper = TransparentPaper.new

paper_complete = false
input.each do |row|
  if row.empty?
    paper_complete = true
    next
  end

  if paper_complete
    axis, position = row.delete_prefix('fold along ').split('=')
    if axis.eql?('x')
      paper.horizontal_fold(position.to_i)
    else
      paper.vertical_fold(position.to_i)
    end
  else
    coordinates = row.split(',').map(&:to_i)
    paper.add_dot(coordinates[0], coordinates[1])
  end
end
#puts paper

puts paper
puts paper.count_points

PGHRKLKL
