# frozen_string_literal: true

module Invaders
  class SimilarityCalculator
    def initialize(weights:)
      @weights = weights
    end

    def calculate_similarity(pattern, radar, start_x, start_y)
      # Return 0.0 if either the pattern or radar is empty or if pattern is larger than radar
      return 0.0 if pattern.x_size == 0 || pattern.y_size == 0 || radar.x_size == 0 || radar.y_size == 0
      return 0.0 if pattern.x_size > radar.x_size || pattern.y_size > radar.y_size

      total_score = 0.0
      max_possible_score = pattern.x_size * pattern.y_size

      # Iterate over every cell in the pattern
      pattern.x_size.times do |x|
        pattern.y_size.times do |y|
          pattern_value = pattern.cell_at(x, y)
          radar_x = start_x + x
          radar_y = start_y + y

          # Calculate the score for this particular cell
          cell_score = calculate_cell_score(
            pattern_value,
            radar,
            radar_x,
            radar_y
          )

          total_score += cell_score # Accumulate the score for the pattern
        end
      end

      total_score / max_possible_score
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
        # Apply a random small noise factor within the noise tolerance range
        noise = @weights[:noise]
        noise_factor = rand * noise
        return noise * noise_factor
      end

      # No match found, return 0.0 score
      return 0.0
    end

    def exact_match?(pattern_value, radar_value)
      pattern_value == radar_value
    end

    def adjacent_match?(pattern_value, radar, x, y)
      # Check all adjacent cells (including diagonals)
      [-1, 0, 1].each do |dx|
        [-1, 0, 1].each do |dy|
          next if dx.zero? && dy.zero? # Skip the cell itself, we're looking for adjacent cells

          adjacent_value = radar.cell_at(x + dx, y + dy)
          return true if adjacent_value == pattern_value
        end
      end
      false # No adjacent match found
    end

    def random_noise?
      rand <= @noise_tolerance # Check if random noise occurs within the noise tolerance
    end
  end
end
