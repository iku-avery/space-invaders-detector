# frozen_string_literal: true

module Invaders
  class SimilarityCalculator
    def initialize(weights:)
      @weights = weights
    end

    def calculate_similarity(pattern, radar, start_x, start_y)
      return 0.0 if pattern.x_size == 0 || pattern.y_size == 0 || radar.x_size == 0 || radar.y_size == 0

      total_score = 0.0
      visible_cells = 0

      # Iterate over every cell in the pattern
      pattern.x_size.times do |x|
        pattern.y_size.times do |y|
          radar_x = start_x + x
          radar_y = start_y + y

          # Skip cells that are outside the radar's bounds
          next unless radar_x.between?(0, radar.x_size - 1) &&
                    radar_y.between?(0, radar.y_size - 1)

          visible_cells += 1
          pattern_value = pattern.cell_at(x, y)

          # Calculate the score for this particular cell
          cell_score = calculate_cell_score(
            pattern_value,
            radar,
            radar_x,
            radar_y
          )

          total_score += cell_score
        end
      end

      # Calculate minimum required visible cells (40% can be hidden)
      min_visible_cells = (pattern.x_size * pattern.y_size * 0.4).ceil

      # Return 0.0 if we don't have enough visible cells
      return 0.0 if visible_cells < min_visible_cells

      # Calculate similarity based only on visible cells
      total_score / visible_cells
    end

    private

    def calculate_cell_score(pattern_value, radar, x, y)
      radar_value = radar.cell_at(x, y)

      # Return 0.0 if radar has no value at this cell (nil)
      return 0.0 if radar_value.nil?

      # Exact match handling
      if exact_match?(pattern_value, radar_value)
        return @weights[:exact]
      end

      # Adjacent match handling
      if adjacent_match?(pattern_value, radar, x, y)
        return @weights[:adjacent]
      end

      # Only apply noise if there are no exact or adjacent matches
      if !exact_match?(pattern_value, radar_value) && !adjacent_match?(pattern_value, radar, x, y)
        noise = @weights[:noise]
        noise_factor = rand * noise
        return noise * noise_factor
      end

      0.0
    end

    def exact_match?(pattern_value, radar_value)
      pattern_value == radar_value
    end

    def adjacent_match?(pattern_value, radar, x, y)
      [-1, 0, 1].each do |dx|
        [-1, 0, 1].each do |dy|
          next if dx.zero? && dy.zero?

          next unless (x + dx).between?(0, radar.x_size - 1) &&
                    (y + dy).between?(0, radar.y_size - 1)

          adjacent_value = radar.cell_at(x + dx, y + dy)
          return true if adjacent_value == pattern_value
        end
      end
      false
    end
  end
end

