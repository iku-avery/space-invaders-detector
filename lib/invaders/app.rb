# frozen_string_literal: true

module Invaders
  class App
    INVADERS_DATA = [
      'data/invaders/invader_01.txt',
      'data/invaders/invader_02.txt'
  ].freeze

    def initialize(matcher: nil)
      @matcher = matcher || Invaders::Matcher.new
      @results  = []
    end

    def scan(file_path, include_rotations)
      @file_path = file_path
      @include_rotations = include_rotations

      puts "Scan #{@file_path}...\n\n"

      radar = load_radar

      patterns = load_patterns

      display_basic_patterns(patterns)

      find_pattern_matches(patterns, radar)
      display_results
    end

    def parser
      @parser ||= Invaders::Parser.new
    end

    private

    def load_radar
      radar = Invaders::Matrix.new
      radar.load_data(File.read(@file_path), parser)
      radar
    end

    def load_patterns
      pattern_library = Invaders::PatternLibrary.new

      INVADERS_DATA.each do |pattern_file|
        matrix = Matrix.new
        matrix.load_data(File.read(pattern_file), parser)

        pattern_library.add_pattern(matrix)
      end

      pattern_library
    end

    def find_pattern_matches(pattern_library, radar)
      @results.clear

      patterns_to_check = if include_rotations?
        pattern_library.all_rotations
      else
        pattern_library.base_patterns
      end

      patterns_to_check.each_with_index do |pattern, pattern_index|
        matches = @matcher.find_matches(pattern, radar)

        matches.each do |match|
          @results << {
            pattern_index: pattern_index,
            match: match,
            rotated: include_rotations?
          }
        end
      end
    end

    def display_results
      return puts "\nNo matches found." if @results.empty?

      puts "\nFound #{@results.length} potential matches:"

      @results.each_with_index do |result, index|
        puts "\nMatch #{index + 1}:"
        puts "Pattern: #{result[:pattern_index] + 1}"
        puts "Position: [#{result[:match].x}, #{result[:match].y}]"
        puts "Similarity: #{(result[:match].similarity * 100).round(2)}%"
      end
    end

    def include_rotations?
      @include_rotations
    end

    def display_basic_patterns(pattern_library)
      puts "Loaded invader patterns:\n\n"
      pattern_library.base_patterns.each_with_index do |pattern_matrix, index|
        puts "Pattern #{index + 1}:"
        pattern_matrix.display
        puts "\n"
      end
    end
  end
end
