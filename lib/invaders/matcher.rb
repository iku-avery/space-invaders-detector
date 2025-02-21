# frozen_string_literal: true
require_relative 'matcher_result'
require_relative 'matcher_config'

module Invaders
  class Matcher
    def initialize(
      similarity_calculator: nil,
      config: Invaders::MatcherConfig.new
    )
      @config = config
      @similarity_calculator = similarity_calculator ||
        Invaders::SimilarityCalculator.new(
          weights: config.weights
        )
    end

    def find_matches(pattern, radar)
      validate_inputs!(pattern, radar)
      matches = []

      # Calculate the minimum visible portion required (40% can be hidden)
      min_visible_x = (pattern.x_size * 0.4).ceil
      min_visible_y = (pattern.y_size * 0.4).ceil

      # Extend search range to include partial patterns at edges
      x_range_start = -(pattern.x_size - min_visible_x)
      x_range_end = radar.x_size - min_visible_x
      y_range_start = -(pattern.y_size - min_visible_y)
      y_range_end = radar.y_size - min_visible_y

      (y_range_start..y_range_end).each do |y|
        (x_range_start..x_range_end).each do |x|
          similarity = @similarity_calculator.calculate_similarity(
            pattern, radar, x, y
          )
          if similarity >= @config.match_threshold
            matches << Invaders::MatcherResult.new(x: x, y: y, similarity: similarity)
          end
        end
      end

      matches
    end

    private

    def validate_inputs!(pattern, radar)
      raise ArgumentError, 'Pattern cannot be nil' if pattern.nil?
      raise ArgumentError, 'Radar cannot be nil' if radar.nil?

      # Remove size validation since we now allow partial patterns
    end
  end
end
