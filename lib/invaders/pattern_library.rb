# frozen_string_literal: true

module Invaders
  class PatternLibrary
    def initialize(patterns = [])
      @patterns = patterns.map { |p| Pattern.new(p) }
    end

    def add_pattern(pattern)
      @patterns << Pattern.new(pattern)
    end

    def all_rotations
      @patterns.flat_map(&:rotations)
    end

    def base_patterns
      @patterns.map(&:matrix)
    end
  end
end
