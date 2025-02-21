require 'spec_helper'
require_relative '../../lib/invaders/matcher'

RSpec.describe Invaders::Matcher do
  let(:pattern) { instance_double('Invaders::Matrix', x_size: 2, y_size: 2) }
  let(:radar) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }
  let(:similarity_calculator) { instance_double('Invaders::SimilarityCalculator') }

  subject(:matcher) do
    described_class.new(
      similarity_calculator: similarity_calculator,
      match_threshold: 0.8
    )
  end

  describe '#find_matches' do
    context 'with valid inputs' do
      before do
        allow(similarity_calculator).to receive(:calculate_similarity)
          .and_return(0.9, 0.7, 0.85, 0.6)
      end

      it 'returns matches above threshold' do
        matches = matcher.find_matches(pattern, radar)
        expect(matches.size).to eq(2)
        expect(matches.map(&:similarity)).to contain_exactly(0.9, 0.85)
      end

      it 'calculates correct match positions' do
        matches = matcher.find_matches(pattern, radar)
        positions = matches.map { |m| [m.x, m.y] }
        expect(positions).to include([0, 0], [0, 1])
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

      context 'when pattern is larger than radar' do
        let(:large_pattern) { instance_double('Invaders::Matrix', x_size: 4, y_size: 4) }

        it 'raises error' do
          expect { matcher.find_matches(large_pattern, radar) }
            .to raise_error(ArgumentError, 'Pattern size exceeds radar size')
        end
      end
    end
  end
end
