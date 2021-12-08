#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day07.rb [input file]'
  exit 1
end

class DigitCracker
  def initialize
    @signals = { } # size => code
    @segments = { } # token => value
  end

  def feed(signal)
    @signals[signal.size] ||= []
    @signals[signal.size] << signal
  end

  def compute
    compute_f
    compute_c
    compute_a
    compute_b
    compute_d
    compute_g
    compute_e
  end

  def crack(value)
    value_map = {
      0 => [true, true, true, false, true, true, true],
      1 => [false, false, true, false, false, true, false],
      2 => [true, false, true, true, true, false, true],
      3 => [true, false, true, true, false, true, true],
      4 => [false, true, true, true, false, true, false],
      5 => [true, true, false, true, false, true, true],
      6 => [true, true, false, true, true, true, true],
      7 => [true, false, true, false, false, true, false],
      8 => [true, true, true, true, true, true, true],
      9 => [true, true, true, true, false, true, true]
    }

    finger_print = ['a', 'b', 'c', 'd', 'e', 'f', 'g'].map do |position|
      value.split('').include?(@segments[position])
    end

    value_map.detect { |_, value_finger_print| value_finger_print.eql?(finger_print) }.first
  end

  private

  def compute_f
    return @segments['f'] if @segments['f']

    eligible_segments = get_eligible_segments(@signals[6], 3)
    @segments['f'] = @signals[2].first.split('').detect { |segment| eligible_segments.include?(segment) }
  end

  def compute_c
    return @segments['c'] if @segments['c']

    @segments['c'] = @signals[2].first.split('').detect { |value| !value.eql?(compute_f) }
  end

  def compute_a
    return @segments['a'] if @segments['a']

    eligible_segments = get_eligible_segments(@signals[5], 3, excluded_segments: [compute_f, compute_c])
    @segments['a'] = @signals[3].first.split('')
                                .detect { |segment| eligible_segments.include?(segment) }
  end

  def compute_b
    return @segments['b'] if @segments['b']

    eligible_segments = get_eligible_segments(@signals[6], 3, excluded_segments: [compute_f, compute_c])
    @segments['b'] = @signals[4].first.split('')
                                .detect { |segment| eligible_segments.include?(segment) }
  end

  def compute_d
    return @segments['d'] if @segments['d']

    eligible_segments = get_eligible_segments(@signals[5], 3)
    @segments['d'] = @signals[4].first.split('')
                                .detect { |segment| eligible_segments.include?(segment) }
  end

  def compute_g
    return @segments['g'] if @segments['g']

    eligible_segments = get_eligible_segments(@signals[5], 3, excluded_segments: [compute_b, compute_a, compute_c, compute_f, compute_d])
    @segments['g'] = eligible_segments.first[0]
  end

  def compute_e
    return @segments['e'] if @segments['e']

    excluded_segments = [compute_a, compute_b, compute_c, compute_d, compute_f, compute_g]
    @segments['e'] = ['a', 'b', 'c', 'd', 'e', 'f', 'g'].detect { |segment| !excluded_segments.include?(segment) }
  end

  def get_eligible_segments(signals, target_occurance, excluded_segments: [])
    signals.map { |signal| signal.split('') }.flatten
           .reject { |segment| excluded_segments.include?(segment) }
           .group_by(&:itself).transform_values!(&:size)
           .select { |_, occurance| occurance == target_occurance }
  end
end

input = InputReader.read_string(ARGV[0])

sum = input.map do |input|
  input.split("|").last.split(" ").map { |value| value.size }.select { |value| [2, 3, 4, 7].include?(value) }.count
end.sum

ap sum

ap (input.map do |single_input|
  cracker = DigitCracker.new
  signals, encoded_value = single_input.split('|')
  signals.split(" ").each { |signal| cracker.feed(signal) }
  cracker.compute

  encoded_value.strip.split(' ').map do |digit|
    cracker.crack(digit).to_s
  end.join.to_i
end).sum

