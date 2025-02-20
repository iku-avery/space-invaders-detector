#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/invaders/app'
require_relative 'lib/invaders/parser'
require_relative 'lib/invaders/matrix'

require 'optparse'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby space_invaders_scanner.rb scan [options]"

  opts.on("-f", "--file FILE", "Path to the radar sample file") do |file|
    options[:file_path] = file
  end
end

parser.parse!

command = ARGV.shift

if command == "scan"
  file_path = options[:file_path] || 'data/radar_sample.txt'

  Invaders::App.new.scan(file_path)
else
  puts "Unknown command! Use: ruby space_invaders_scanner.rb scan [options]"
end
