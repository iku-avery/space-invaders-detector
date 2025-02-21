# frozen_string_literal: true
require_relative 'matcher_result'

module Invaders
  class Matcher
    MATCH_THRESHOLD = 0.8
    DEFAULT_WEIGHTS = {
      exact: 1.0,    # Exact cell match
      adjacent: 0.2, # Match in adjacent cell
      noise: 0.2     # Small random noise threshold
    }.freeze

    def initialize(
      similarity_calculator: nil,
      match_threshold: MATCH_THRESHOLD,
      weights: DEFAULT_WEIGHTS
    )
      @match_threshold = match_threshold
      @similarity_calculator = similarity_calculator ||
        Invaders::SimilarityCalculator.new(
          weights: weights
        )
    end

    def find_matches(pattern, radar)
      validate_inputs!(pattern, radar)
      matches = []

      (0..radar.y_size - pattern.y_size).each do |y|
        (0..radar.x_size - pattern.x_size).each do |x|
          similarity = @similarity_calculator.calculate_similarity(
            pattern, radar, x, y
          )
          if similarity >= @match_threshold
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
      raise ArgumentError, 'Pattern size exceeds radar size' if pattern.x_size > radar.x_size || pattern.y_size > radar.y_size
    end
  end
end
