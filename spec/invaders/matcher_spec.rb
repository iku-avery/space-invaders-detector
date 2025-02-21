require 'spec_helper'
require_relative '../../lib/invaders/matcher'

RSpec.describe Invaders::Matcher do
  let(:pattern) { instance_double('Invaders::Matrix', x_size: 2, y_size: 2) }
  let(:radar) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }
  let(:similarity_calculator) { instance_double('Invaders::SimilarityCalculator') }
  let(:matcher_config) { instance_double('Invaders::MatcherConfig', match_threshold: 0.8) }

  subject(:matcher) do
    described_class.new(
      similarity_calculator: similarity_calculator,
      config: matcher_config
    )
  end

  describe '#find_matches' do
    context 'with fully visible patterns' do
      before do
        allow(similarity_calculator).to receive(:calculate_similarity) do |_, _, x, y|
          case [x, y]
          when [0, 0] then 0.9
          when [0, 1] then 0.85
          else 0.6
          end
        end
      end

      it 'returns matches above threshold' do
        matches = matcher.find_matches(pattern, radar)
        expect(matches.size).to eq(2)
        expect(matches.map(&:similarity)).to contain_exactly(0.9, 0.85)
      end

      it 'calculates correct match positions' do
        matches = matcher.find_matches(pattern, radar)
        positions = matches.map { |m| [m.x, m.y] }
        expect(positions).to contain_exactly([0, 0], [0, 1])
      end
    end

    context 'with partially visible patterns' do
      let(:pattern) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }

      before do
        allow(similarity_calculator).to receive(:calculate_similarity) do |_, _, x, y|
          case [x, y]
          when [-1, 0] then 0.85  # Left edge
          when [1, -1] then 0.82  # Top edge
          when [2, 2] then 0.87   # Bottom-right corner
          else 0.6
          end
        end
      end

      it 'finds matches at negative coordinates (left edge)' do
        matches = matcher.find_matches(pattern, radar)
        expect(matches).to include(
          have_attributes(x: -1, y: 0, similarity: 0.85)
        )
      end

      it 'finds matches at negative coordinates (top edge)' do
        matches = matcher.find_matches(pattern, radar)
        expect(matches).to include(
          have_attributes(x: 1, y: -1, similarity: 0.82)
        )
      end
    end

    context 'with invalid inputs' do
      it 'raises error for nil pattern' do
        expect { matcher.find_matches(nil, radar) }
          .to raise_error(ArgumentError, 'Pattern cannot be nil')
      end

      it 'raises error for nil radar' do
        expect { matcher.find_matches(pattern, nil) }
          .to raise_error(ArgumentError, 'Radar cannot be nil')
      end
    end
  end
end
