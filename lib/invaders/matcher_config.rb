# frozen_string_literal: true

module Invaders
  # Handles the configuration and setup of matching parameters
  class MatcherConfig
    MATCH_THRESHOLD = 0.8
    DEFAULT_WEIGHTS = {
      exact: 1.0,    # Exact cell match
      adjacent: 0.2, # Match in adjacent cell
      noise: 0.2     # Small random noise threshold
    }.freeze

    attr_reader :match_threshold, :weights

    def initialize(match_threshold: MATCH_THRESHOLD, weights: DEFAULT_WEIGHTS)
      @match_threshold = match_threshold
      @weights = weights.freeze
    end
  end
end
