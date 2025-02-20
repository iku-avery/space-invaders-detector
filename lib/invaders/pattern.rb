# frozen_string_literal: true

module Invaders
  class Pattern
    attr_reader :matrix

    def initialize(matrix)
      @matrix = matrix
    end

    def rotations
      @rotations ||= generate_rotations
    end

    private

    def generate_rotations
      rotations = [@matrix]
      current = @matrix

      3.times do
        current = rotate_90_degrees(current)
        rotations << current
      end

      rotations
    end

    def rotate_90_degrees(matrix)
      rows = matrix.y_size
      cols = matrix.x_size
      rotated_data = Array.new(cols) { Array.new(rows, 0) }

      rows.times do |i|
        cols.times do |j|
          rotated_data[j][rows - 1 - i] = matrix.cell_at(j, i)
        end
      end

      Invaders::Matrix.new(rotated_data)
    end
  end
end
