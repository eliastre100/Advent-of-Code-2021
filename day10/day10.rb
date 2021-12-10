#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day10.rb [input file]'
  exit 1
end

instructions = InputReader.read_string(ARGV[0])

def illegal_token(tokens, state)
  return { illegal: false, state: state, error: '' } if tokens.size.zero?

  token_pairs = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }

  if token_pairs.keys.include?(tokens[0])
    state << tokens[0]
  else
    return { illegal: true, state: state, error: tokens[0] } unless token_pairs[state.last].eql?(tokens[0])

    state.pop
  end

  illegal_token(tokens.drop(1), state)
end

invalid_tokens = instructions.map do |instruction|
  illegal_token(instruction.split(''), [])
end.compact

error_prices = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
  '' => 0
}

ap (invalid_tokens.select { |instruction| instruction[:illegal] }.map do |invalid_token|
  error_prices[invalid_token[:error]]
end.sum)

autocomplete_prices = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

autocomplete_contest = invalid_tokens.reject { |instruction| instruction[:illegal] }.map do |instruction|
  instruction[:state].reverse.inject(0) do |acc, closing_token|
    acc = acc * 5 + autocomplete_prices[closing_token]
  end
end

ap autocomplete_contest.sort[autocomplete_contest.size / 2]
