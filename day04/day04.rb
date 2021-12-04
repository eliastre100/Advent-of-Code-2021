#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day04.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])

class Bingo
  def initialize
    @rows = []
  end

  def add_row(row_values)
    @rows << row_values.map { |value| { found: false, value: value} }
  end

  def to_s
    @rows.map do |row|
      row.map { |cell| cell[:found] ? '*' : cell[:value] }.join(' ')
    end.join("\n")
  end

  def apply(value)
    @rows.each.with_index do |row, y|
      row.each.with_index do |cell, x|
        @rows[y][x][:found] = true if cell[:value] == value
      end
    end
  end

  def won?
    @rows.any? do |row|
      row.reject { |cell| cell[:found] }.empty?
    end || (0..@rows[0].size - 1).any? do |column_id|
      @rows.reject { |row| row[column_id][:found] }.empty?
    end
  end

  def remaining_score
    @rows.map do |row|
      row.map do |cell|
        cell[:found] ? 0 : cell[:value]
      end
    end.flatten.inject(&:+)
  end
end

draws = input.first.split(',').map(&:to_i)
bingos = [Bingo.new]

input.drop(2).map(&:split).map.each do |line|
  if line.empty?
    bingos << Bingo.new
    next
  end

  bingos.last.add_row(line.map(&:to_i))
end

last_usefull_draw = draws.detect do |draw|
  bingos.each { |bingo| bingo.apply(draw) }
  bingos.any?(&:won?)
end

winner = bingos.detect(&:won?)

puts "Last value drawn #{last_usefull_draw.inspect} and the winner have #{winner.remaining_score} (answer = #{last_usefull_draw * winner.remaining_score})"
puts winner

remaining_boards = bingos

draws.each do |draw|
  remaining_boards.each { |bingo| bingo.apply(draw) }
  remaining_boards = remaining_boards.reject(&:won?)
  break if remaining_boards.one?
end

last_looser_draw = draws.detect do |draw|
  remaining_boards.first.apply(draw)
  remaining_boards.first.won?
end

puts "Last value drawn to looser's completion #{last_looser_draw.inspect} and the looser have #{remaining_boards.last.remaining_score} (answer = #{last_looser_draw * remaining_boards.last.remaining_score})"
