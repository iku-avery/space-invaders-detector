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

  # Restrict match threshold to three specific values: 0.8, 0.9, 1.0
  opts.on("--match-threshold THRESHOLD", "Set the match threshold (0.8, 0.9, 1.0)") do |threshold|
    threshold = threshold.to_f
    unless [0.8, 0.9, 1.0].include?(threshold)
      raise OptionParser::InvalidArgument, "Invalid threshold value. Choose from 0.8, 0.9, or 1.0."
    end
    options[:match_threshold] = threshold
  end
end

parser.parse!

command = ARGV.shift

if command == "scan"
  file_path = options[:file_path] || 'data/radar_sample.txt'
  include_rotations = options[:include_rotations]
  match_threshold = options[:match_threshold] || 0.8  # Default to 0.8 if no value is provided

  # Pass the match_threshold only if it's specified, else use default config
  config = Invaders::MatcherConfig.new(match_threshold: match_threshold)

  Invaders::App.new(matcher: Invaders::Matcher.new(config: config)).scan(file_path, include_rotations)
else
  puts "Unknown command! Use: ruby space_invaders_scanner.rb scan [options]"
end
