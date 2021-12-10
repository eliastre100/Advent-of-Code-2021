#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day10.rb [input file]'
  exit 1
end

instructions = InputReader.read_string(ARGV[0])

def illegal_token(tokens, state)
  return nil if tokens.size.zero?

  token_pairs = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }

  if token_pairs.keys.include?(tokens[0])
    state << tokens[0]
  else
    return tokens[0] unless token_pairs[state.last].eql?(tokens[0])

    state.pop
  end

  illegal_token(tokens.drop(1), state)
end

invalid_tokens = instructions.map do |instruction|
  puts instruction
  illegal_token(instruction.split(''), [])
end.compact

error_prices = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

ap (invalid_tokens.map do |invalid_token|
  error_prices[invalid_token]
end.sum)
