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

      (0..radar.y_size - pattern.y_size).each do |y|
        (0..radar.x_size - pattern.x_size).each do |x|
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
      raise ArgumentError, 'Pattern size exceeds radar size' if pattern.x_size > radar.x_size || pattern.y_size > radar.y_size
    end
  end
end
