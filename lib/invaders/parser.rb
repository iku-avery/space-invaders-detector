# frozen_string_literal: true

module Invaders
  class InvalidDataError < StandardError; end

  class Parser
    attr_reader :cell_char, :empty_cell_char

    def initialize(cell_char: 'o', empty_cell_char: '-')
      validate_chars!(cell_char, empty_cell_char)
      @cell_char = cell_char
      @empty_cell_char = empty_cell_char
    end

    def parse(data)
      raise InvalidDataError, 'Input data cannot be nil' if data.nil?
      raise InvalidDataError, 'Input data must be a string' unless data.is_a?(String)

      lines = parse_lines(data)
      validate_parsed_data!(lines)
      lines
    end

    private

    def parse_lines(data)
      data.each_line(chomp: true).map do |line|
        parse_line(line)
      end
    end

    def parse_line(line)
      line.each_char.map do |char|
        convert_char_to_cell(char)
      end
    end

    def convert_char_to_cell(char)
      case char
      when cell_char then 1
      when empty_cell_char then 0
      else -1
      end
    end

    def validate_chars!(cell_char, empty_cell_char)
      raise ArgumentError, 'Characters must be single characters' unless [cell_char, empty_cell_char].all? { |char| char.is_a?(String) && char.length == 1 }
      raise ArgumentError, 'Characters must be different' if cell_char == empty_cell_char
    end

    def validate_parsed_data!(lines)
      raise InvalidDataError, 'No valid lines found in input' if lines.empty?

      line_lengths = lines.map(&:length).uniq
      raise InvalidDataError, 'All lines must have the same length' if line_lengths.size > 1
      raise InvalidDataError, 'Lines cannot be empty' if line_lengths.first.zero?
    end
  end
end

