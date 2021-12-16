#!/usr/bin/env ruby

require_relative '../utils/input_reader'
require 'awesome_print'

if ARGV.empty?
  warn 'Usage: ./day16.rb [input file]'
  exit 1
end

input = InputReader.read_string(ARGV[0])[0]

module Type4Packet
  def value
    (0..number_groups - 1).map do |idx|
      group_start = idx * 5 + 1
      group_end = (idx + 1) * 5 - 1
      payload[group_start..group_end]
    end.join.to_i(2)
  end

  def data_start
    6
  end

  def packet_size
    return @packet_size if @packet_size

    @packet_size = data_start + number_groups * 5
  end

  def number_groups
    return @number_groups if @number_groups

    @number_groups = 0
    @number_groups += 1 while payload[@number_groups * 5] != '0' || payload[@number_groups * 5].nil?
    @number_groups += 1
  end

  def payload_size
    number_groups * 5
  end

  def sub_packets
    []
  end
end

module TypeLengthId0Packet
  def value
    nil
  end

  def data_start
    3 + 3 + 1 + 15
  end

  def packet_size
    data_start + payload_size
  end

  def payload_size
    @payload_size ||= @binary[7..data_start - 1].to_i(2)
  end

  def binary_size
    data_start + payload_size
  end

  def sub_packets
    return @sub_packets if @sub_packets

    @sub_packets = []
    read = 0
    while read < payload_size
      @sub_packets << Packet.new(payload[read..payload_size - 1], binary: true)
      read += @sub_packets.last.packet_size
    end
    @sub_packets
  end
end

module TypeLengthId1Packet
  def value
    nil
  end

  def data_start
    3 + 3 + 1 + 11
  end

  def number_sub_packets
    @number_sub_packets ||= @binary[7..data_start - 1].to_i(2)
  end

  def packet_size
    data_start + payload_size
  end

  def payload_size
    sub_packets.map(&:packet_size).sum
  end

  def binary_size
    data_start + payload_size
  end

  def sub_packets
    return @sub_packets if @sub_packets

    @sub_packets = []
    read = 0
    ap payload
    while @sub_packets.size < number_sub_packets
      @sub_packets << Packet.new(@binary[data_start + read..-1], binary: true)
      read += @sub_packets.last.packet_size
    end
    @sub_packets
  end

  def to_s
    super + "number of sub-packets: #{number_sub_packets}"
  end
end

class Packet
  attr_reader :binary

  def initialize(value, binary: false)
    @binary = if binary
                value
              else
                value.hex.to_s(2).rjust(value.size * 4, '0')
              end
    integrate_packet_specifics
    puts self
  end

  def to_s
    "## Packet details ##\n" +
      "binary: #{binary}" + "\n" +
      "payload: #{payload}\n" +
      "version: #{packet_version}\n" +
      "opcode: #{op_code}\n" +
      "packet_size: #{packet_size}\n" +
      "payload_size: #{payload_size}\n" +
      "value: #{value}\n"
  end

  def packet_version
    @binary[0..2].to_i(2)
  end

  def op_code
    ap @binary
    @binary[3..5].to_i(2)
  end

  def packet_size
    throw NotImplementedError
  end

  def value
    throw NotImplementedError
  end

  def version_checksum
    packet_version + sub_packets.map(&:version_checksum).sum
  end

  private

  def integrate_packet_specifics
    if op_code == 4
      extend(Type4Packet)
    elsif @binary[6] == '0'
      extend(TypeLengthId0Packet)
    else
      extend(TypeLengthId1Packet)
    end
  end

  def payload
    @binary[data_start..binary_size - 1]
  end

  def binary_size
    @binary.size
  end

  def payload_size
    payload.size
  end

  def data_start
    throw NotImplementedError
  end

  def sub_packets
    throw NotImplementedError
  end
end

packet = Packet.new(input)

puts packet.version_checksum
#packet.sub_packets.each_with_index { |p, i| ap "#{i} => #{p.send(:payload)} #{p.op_code} #{p.packet_size} #{p.value}" }
