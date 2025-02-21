#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/invaders/app'
require_relative 'lib/invaders/parser'
require_relative 'lib/invaders/matrix'
require_relative 'lib/invaders/pattern'
require_relative 'lib/invaders/pattern_library'
require_relative 'lib/invaders/similarity_calculator'
require_relative 'lib/invaders/matcher'
require_relative 'lib/invaders/matcher_result'

require 'optparse'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby space_invaders_scanner.rb scan [options]"

  opts.on("-f", "--file FILE", "Path to the radar sample file") do |file|
    options[:file_path] = file
  end

  opts.on("--include-rotations", "Include rotations of invader patterns") do
    options[:include_rotations] = true
  end
end

parser.parse!

command = ARGV.shift

if command == "scan"
  file_path = options[:file_path] || 'data/radar_sample.txt'
  include_rotations = options[:include_rotations]

  Invaders::App.new.scan(file_path, include_rotations)
else
  puts "Unknown command! Use: ruby space_invaders_scanner.rb scan [options]"
end
