#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day10.rb [input file]'
  exit 1
end

instructions = InputReader.read_string(ARGV[0])

class Cavern
  attr_accessor :flashes, :current_step

  def initialize
    @octopuses = {}
    @height = 0
    @width = 0
    @flashes = 0
    @current_step = 0
  end

  def feed(line)
    line.each.with_index do |power, x|
      @octopuses[[x, @height]] = { flashed: false, power: power }
    end
    @height += 1
    @width = line.size
  end

  def step
    puts "step #{@current_step + 1}"
    @octopuses.each do |_, octopus|
      octopus[:power] = 0 if octopus[:power] > 9 && octopus[:flashed]
      octopus[:flashed] = false
      octopus[:power] += 1
    end
    @current_step += 1
    flash.tap do |step_flashes|
      @flashes += step_flashes
    end
  end

  def synchronize
    needed_flashes = @width * @height
    loop do
      break if step == needed_flashes
    end
  end

  def to_s
    (0..@height - 1).map do |y|
      (0..@width - 1).map do |x|
        if @octopuses[[x, y]][:flashed]
          "*#{@octopuses[[x, y]][:power].to_s.rjust(2, ' ')}*"
        else
          " #{@octopuses[[x, y]][:power].to_s.rjust(2, ' ')} "
        end
      end.join(" | ")
    end.join("\n")
  end

  private

  def flash(base_flash = 0)
    flash_report = @octopuses.map do |position, octopus|
      if octopus[:power] > 9 && !octopus[:flashed]
        puts "#{position[0]}, #{position[1]} flashed !"
        increase_neighbours(position[0], position[1])
        octopus[:flashed] = true
        { flashed: true }
      else
        { flashed: false }
      end
    end
    flashes_count = flash_report.count { |report| report[:flashed] }
    if flashes_count.zero?
      base_flash
    else
      flash(flashes_count + base_flash)
    end
  end

  def increase_neighbours(x, y)
    [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0],           [1, 0],
      [-1, 1],  [0, 1],  [1, 1]
    ].each do |modifier|
      @octopuses[[x + modifier[0], y + modifier[1]]][:power] += 1 unless x + modifier[0] < 0 || x + modifier[0] >= @width || y + modifier[1] < 0 || y + modifier[1] >= @height
    end
  end
end

cavern = Cavern.new

instructions.each { |row| cavern.feed(row.split('').map(&:to_i)) }

puts cavern
(0..99).each do |x|
  puts "Step #{x + 1}"
  cavern.step
  puts cavern
end

puts cavern.flashes

cavern.synchronize

puts cavern.current_step
