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

      it 'returns 0 when there are no exact or adjacent matches' do
        # Assuming pattern has values different from radar
        allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 1)
        allow(radar).to receive(:cell_at).and_return(0, 0, 0, 0)

        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to be_within(0.1).of(0.0) # Allow a small error margin due to noise
      end
    end

    # Empty pattern and radar
    context 'with empty pattern and radar' do
      let(:pattern_empty) { instance_double('Invaders::Matrix', x_size: 0, y_size: 0) }
      let(:radar_empty) { instance_double('Invaders::Matrix', x_size: 0, y_size: 0) }

      it 'returns 0.0 for empty pattern and radar' do
        similarity = calculator.calculate_similarity(pattern_empty, radar_empty, 0, 0)
        expect(similarity).to eq(0.0)
      end
    end

    # Pattern larger than radar
    context 'with pattern larger than radar' do
      let(:pattern_large) { instance_double('Invaders::Matrix', x_size: 3, y_size: 3) }
      let(:radar_small) { instance_double('Invaders::Matrix', x_size: 2, y_size: 2) }

      before do
        allow(pattern_large).to receive(:cell_at).and_return(1, 1, 1, 0, 0, 0, 1, 0, 1)
        allow(radar_small).to receive(:cell_at).and_return(1, 0, 1, 0)
      end

      it 'returns 0.0 for patterns larger than radar' do
        similarity = calculator.calculate_similarity(pattern_large, radar_small, 0, 0)
        expect(similarity).to eq(0.0)
      end
    end

    # Radar with missing values (nil)
    context 'with radar having missing values' do
      before do
        allow(radar).to receive(:cell_at).and_return(1, nil, 1, 0)
      end

      it 'handles missing radar values gracefully' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to be_between(0.5, 0.75)
      end
    end

    context 'with no exact or adjacent matches' do
      before do
        # Ensure both pattern and radar cells have non-matching values
        allow(pattern).to receive(:cell_at).and_return(1, 1, 1, 1)  # All 1s in pattern
        allow(radar).to receive(:cell_at).and_return(0, 0, 0, 0)  # All 0s in radar
      end

      it 'returns a small value when there are no exact or adjacent matches (due to noise)' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to be_within(0.1).of(0.0) # Small noise is allowed
      end
    end

    # Noise tolerance test (random noise)
    context 'with random noise' do
      it 'accounts for noise tolerance correctly' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)

        expect(similarity).to be_between(0.0, 1.0).inclusive
      end
    end

    # Handling boundary cells
    context 'with boundary cells in radar' do
      it 'handles boundary cells correctly' do
        # Pattern with cells at the boundary of radar
        allow(radar).to receive(:cell_at).and_return(1, 0, 1, 0)
        similarity = calculator.calculate_similarity(pattern, radar, 1, 1) # Corner case
        expect(similarity).to eq(1.0) # Assuming exact match for corner cells
      end
    end

    # Fully matched pattern
    context 'with a fully matched pattern' do
      before do
        allow(radar).to receive(:cell_at).and_return(1, 0, 1, 0)
      end

      it 'returns 1.0 for a fully matched pattern' do
        similarity = calculator.calculate_similarity(pattern, radar, 0, 0)
        expect(similarity).to eq(1.0)
      end
    end

    # Pattern and radar with different sizes (aspect ratio)
    context 'with pattern and radar having different aspect ratios' do
      let(:pattern_tall) { instance_double('Invaders::Matrix', x_size: 2, y_size: 3) }
      let(:radar_wide) { instance_double('Invaders::Matrix', x_size: 3, y_size: 2) }

      before do
        allow(pattern_tall).to receive(:cell_at).and_return(1, 0, 1, 1, 0, 0)
        allow(radar_wide).to receive(:cell_at).and_return(1, 1, 0, 0, 1, 0)
      end

      it 'calculates similarity correctly for non-square matrices' do
        similarity = calculator.calculate_similarity(pattern_tall, radar_wide, 0, 0)
        expect(similarity).to be_between(0.0, 1.0)
      end
    end
  end
end
