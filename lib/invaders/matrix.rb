# frozen_string_literal: true

module Invaders
  class Matrix
    attr_reader :x_size, :y_size

    def initialize(data = [])
      @data = data
      recalculate_size
    end

    def cell_at(x, y)
      return nil unless valid_position?(x, y)
      @data[y][x]
    end

    def add_line(line)
      @data << line
      recalculate_size
    end

    def display(cell_char: 'o', empty_cell_char: '-')
      @data.each do |line|
        puts line.map { |cell| cell == 1 ? cell_char : empty_cell_char }.join
      end
    end

    def load_data(data, parser)
      raise ArgumentError, 'Parser cannot be nil' if parser.nil?

      parsed_data = parser.parse(data)
      @data = parsed_data.map(&:dup)
      recalculate_size
    end

    def to_a
      @data.map(&:dup)
    end

    private

    def recalculate_size
      @y_size = @data.size
      @x_size = @data.first&.size || 0
    end

    def valid_position?(x, y)
      x.between?(0, x_size - 1) && y.between?(0, y_size - 1)
    end
  end
end
