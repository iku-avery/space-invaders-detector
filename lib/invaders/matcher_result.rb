# frozen_string_literal: true

module Invaders
  class MatcherResult
    attr_reader :x, :y, :similarity

    def initialize(x:, y:, similarity:)
      @x = x
      @y = y
      @similarity = similarity
    end

    def to_h
      {
        x: @x,
        y: @y,
        similarity: @similarity
      }
    end
  end
end
