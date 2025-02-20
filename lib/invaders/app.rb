# frozen_string_literal: true

module Invaders
  class App
    INVADERS_DATA = [
      'data/invaders/invader_01.txt',
      'data/invaders/invader_02.txt'
  ].freeze

    def scan(file_path, show_rotations)
      @file_path = file_path

      puts "Scan #{@file_path}...\n\n"

      load_radar

      patterns = load_patterns

      if show_rotations
        display_rotations(patterns)
      else
        display_basic_patterns(patterns)
      end
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

    def display_basic_patterns(pattern_library)
      puts "Loaded invader patterns:\n\n"
      pattern_library.base_patterns.each_with_index do |pattern_matrix, index|
        puts "Pattern #{index + 1}:"
        pattern_matrix.display
        puts "\n"
      end
    end

    def display_rotations(pattern_library)
      puts "Loaded invader patterns (including rotations):\n\n"
      pattern_library.all_rotations.each_with_index do |pattern_matrix, index|
        puts "Rotation #{index + 1}:"
        pattern_matrix.display
        puts "\n"
      end
    end
  end
end
