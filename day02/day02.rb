#!/usr/bin/env ruby

if ARGV.empty?
  warn 'Usage: ./day02.rb [input file]'
  exit 1
end

class InputReader
  class << self
    def read_commands(file)
      File.readlines(file).map do |line|
        command = line.split(' ')
        {
          command: command[0],
          argument: command[1].to_i
        }
      end
    end
  end
end

class Submarine
  attr_reader :depth, :position

  def initialize
    @depth = 0
    @position = 0
  end

  def apply_forward(value)
    @position += value
  end

  def apply_depth(value)
    @depth += value
  end
end

submarine = Submarine.new

InputReader.read_commands(ARGV[0]).each do |command|
  case command[:command]
    when "down"
      submarine.apply_depth(command[:argument])
    when "up"
      submarine.apply_depth(-command[:argument])
    when "forward"
      submarine.apply_forward(command[:argument])
  end
end

puts "You are at #{submarine.position} and depth #{submarine.depth} (#{submarine.position * submarine.depth})"
