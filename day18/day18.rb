#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day17.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class SnailfishNumber
  attr_reader :pair

  class << self
    def parse(input)
      split_position = group_split_position(input)
      left = input[1].eql?('[') ? parse(input[1..split_position - 1]) : input[1..split_position - 1].to_i
      right = input[split_position + 1].eql?('[') ? parse(input[split_position + 1..-2]) : input[split_position + 1..-2].to_i

      SnailfishNumber.new([left, right])
    end

    private

    def group_split_position(input)
      depth = 0
      (1..input.size - 1).each do |idx|
        if input[idx].eql?('[')
          depth += 1
        elsif input[idx].eql?(']')
          depth -= 1
        elsif input[idx].eql?(',') && depth == 0
          return idx
        end
      end
    end
  end

  def initialize(pair)
    @pair = pair
  end

  def to_s
    "[#{@pair[0].to_s},#{@pair[1].to_s}]"
  end

  def reduce
    while explode_child(0) || split; end
  end

  def magnitude
    left_value * 3 + right_value * 2
  end

  def +(other)
    SnailfishNumber.new([self, other])
  end

  private

  def explode
    explode_child(0)
  end

  def explode_child(depth)
    if depth >= 4
      return { left: left, right: right, consumed: false }
    elsif left.is_a?(SnailfishNumber) && (explosion = left.send(:explode_child, depth + 1))
      return apply_explosion(explosion, :left)
    elsif right.is_a?(SnailfishNumber) && (explosion = right.send(:explode_child, depth + 1))
      return apply_explosion(explosion, :right)
    end

    false
  end

  def apply_explosion(explosion, explosion_direction)
    case explosion_direction
    when :right
      if left.is_a?(SnailfishNumber)
        explosion[:left] = 0 if left.send(:apply_from_right, explosion[:left])
      else
        # We have a number
        @pair[0] += explosion[:left]
        explosion[:left] = 0
      end
    when :left
      if right.is_a?(SnailfishNumber)
        explosion[:right] = 0 if right.send(:apply_from_left, explosion[:right])
      else
        @pair[1] += explosion[:right]
        explosion[:right] = 0
      end
    end

    unless explosion[:consumed]
      if left.is_a?(SnailfishNumber)
        @pair[0] = 0
      elsif right.is_a?(SnailfishNumber)
        @pair[1] = 0
      end
      explosion[:consumed] = true
    end

    explosion
  end

  def apply_from_left(value)
    if left.is_a?(SnailfishNumber)
      return true if left.send(:apply_from_left, value)
    else
      @pair[0] += value
      return true
    end

    if right.is_a?(SnailfishNumber)
      return true if right.send(:apply_from_left, value)
    else
      @pair[1] += value
      return true
    end

    false
  end

  def apply_from_right(value)
    if right.is_a?(SnailfishNumber)
      return true if right.send(:apply_from_right, value)
    else
      @pair[1] += value
      return true
    end

    if left.is_a?(SnailfishNumber)
      return true if left.send(:apply_from_right, value)
    else
      @pair[0] += value
      return true
    end

    false
  end

  def split
    if left.is_a?(SnailfishNumber)
      return true if left.send(:split)
    elsif left >= 10
      @pair[0] = SnailfishNumber.new([(left.to_f / 2).floor.to_i, (left.to_f / 2).ceil.to_i])
      return true
    end

    if right.is_a?(SnailfishNumber)
      return true if right.send(:split)
    elsif right >= 10
      @pair[1] = SnailfishNumber.new([(right.to_f / 2).floor.to_i, (right.to_f / 2).ceil.to_i])
      return true
    end

    false
  end

  def left
    @pair[0]
  end

  def right
    @pair[1]
  end

  def left_value
    if left.is_a?(SnailfishNumber)
      left.magnitude
    else
      left
    end
  end

  def right_value
    if right.is_a?(SnailfishNumber)
      right.magnitude
    else
      right
    end
  end

  def left_most_value
    if left.is_a?(SnailfishNumber)
      left.send(:left_most_value)
    else
      left
    end
  end

  def right_most_value
    if right.is_a?(SnailfishNumber)
      right.send(:left_most_value)
    else
      right
    end
  end
end

# Part 1

n = SnailfishNumber.parse(input.first)

input.drop(1).each do |number_str|
  n = n + SnailfishNumber.parse(number_str)
  n.reduce
end

puts n.to_s
puts n.magnitude

# Part 2

max_magniture = input.combination(2).map do |combination|
  [
    [SnailfishNumber.parse(combination[0]), SnailfishNumber.parse(combination[1])],
    [SnailfishNumber.parse(combination[1]), SnailfishNumber.parse(combination[0])]
  ]
end.flatten(1).map do |combination|
  t = combination[0] + combination[1]
  t.reduce
  t.magnitude
end.max

puts max_magniture
