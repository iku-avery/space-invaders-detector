require 'spec_helper'
require_relative '../../lib/invaders/similarity_calculator'

RSpec.describe Invaders::SimilarityCalculator do
  let(:pattern) { instance_double('Invaders::Matrix', x_size: 2, y_size: 2) }
  let(:radar) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }

  subject(:calculator) do
    described_class.new(
      weights: { exact: 1.0, adjacent: 0.5, noise: 0.2 }
    )
  end

  describe '#calculate_similarity' do
    before do
      allow(pattern).to receive(:cell_at).and_return(1, 0, 1, 0)
      allow(radar).to receive(:cell_at).and_return(1, 0, 1, 0)
    end

    context 'with fully visible patterns' do
      it 'calculates exact matches correctly' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to eq(1.0)
      end

      context 'with adjacent matches' do
        before do
          allow(radar).to receive(:cell_at).and_return(0, 1, 1, 0)
        end

        it 'considers adjacent cells in similarity calculation' do
          similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
          expect(similarity).to be_between(0.5, 0.75)
        end
      end
    end

    context 'with partially visible patterns' do
      let(:pattern) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }

      context 'when pattern is partially outside left edge' do
        before do
          allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 0, 0, 0, 1, 1, 1)
          # Only cells within radar bounds return values
          allow(radar).to receive(:cell_at) do |x, y|
            x >= 0 && y >= 0 ? 1 : nil
          end
        end

        it 'calculates similarity based on visible portion' do
          similarity = calculator.calculate_similarity(pattern, radar, -1, 0)
          expect(similarity).to be > 0.0
        end
      end

      context 'when pattern is partially outside top edge' do
        before do
          allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 0, 0, 0, 1, 1, 1)
          allow(radar).to receive(:cell_at) do |x, y|
            y >= 0 ? 1 : nil
          end
        end

        it 'calculates similarity based on visible portion' do
          similarity = calculator.calculate_similarity(pattern, radar, 0, -1)
          expect(similarity).to be > 0.0
        end
      end

      context 'when pattern is mostly outside radar (less than 40% visible)' do
        before do
          allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 0, 0, 0, 1, 1, 1)
          allow(radar).to receive(:cell_at).and_return(nil)
        end

        it 'returns 0.0 for insufficient visibility' do
          similarity = calculator.calculate_similarity(pattern, radar, -2, -2)
          expect(similarity).to eq(0.0)
        end
      end
    end

    context 'with empty pattern or radar' do
      let(:pattern_empty) { instance_double('Invaders::Matrix', x_size: 0, y_size: 0) }
      let(:radar_empty) { instance_double('Invaders::Matrix', x_size: 0, y_size: 0) }

      it 'returns 0.0 for empty pattern and radar' do
        similarity = calculator.calculate_similarity(pattern_empty, radar_empty, 0, 0)
        expect(similarity).to eq(0.0)
      end
    end

    context 'with radar having missing values' do
      before do
        allow(radar).to receive(:cell_at).and_return(1, nil, 1, 0)
      end

      it 'handles missing radar values gracefully' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to be_between(0.0, 1.0)
      end
    end

    context 'with no exact or adjacent matches' do
      before do
        allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 1)
        allow(radar).to receive(:cell_at).and_return(0, 0, 0, 0)
      end

      it 'returns a small value when there are no matches (due to noise)' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to be_within(0.1).of(0.0)
      end
    end

    context 'with boundary and edge cases' do
      let(:pattern) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }

      before do
        allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 0, 0, 0, 1, 1, 1)
      end

      it 'handles right edge correctly' do
        allow(radar).to receive(:cell_at) do |x, y|
          x < radar.x_size ? 1 : nil
        end
        similarity = calculator.calculate_similarity(pattern, radar, 1, 1)
        expect(similarity).to be > 0.0
      end

      it 'handles bottom edge correctly' do
        allow(radar).to receive(:cell_at) do |x, y|
          y < radar.y_size ? 1 : nil
        end
        similarity = calculator.calculate_similarity(pattern, radar, 1, 1)
        expect(similarity).to be > 0.0
      end
    end

    context 'with different aspect ratios' do
      let(:pattern_tall) { instance_double('Invaders::Matrix', x_size: 2, y_size: 3) }

      before do
        allow(pattern_tall).to receive(:cell_at).and_return(1, 0, 1, 1, 0, 0)
        allow(radar).to receive(:cell_at).and_return(1, 0, 1, 0)
      end

      it 'calculates similarity correctly for partial visibility' do
        similarity = calculator.calculate_similarity(pattern_tall, radar, 0, -1)
        expect(similarity).to be_between(0.0, 1.0)
      end
    end
  end
end
