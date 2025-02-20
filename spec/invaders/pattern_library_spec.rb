require 'spec_helper'
require_relative '../../lib/invaders/pattern_library'
require_relative '../../lib/invaders/pattern'

RSpec.describe Invaders::PatternLibrary do
  let(:pattern1) { instance_double('Invaders::Matrix') }
  let(:pattern2) { instance_double('Invaders::Matrix') }

  subject(:library) { described_class.new([pattern1, pattern2]) }

  describe '#all_rotations' do
    before do
      allow_any_instance_of(Invaders::Pattern).to receive(:rotations).and_return([double, double])
    end

    it 'returns all pattern variations including rotations' do
      expect(library.all_rotations.size).to eq(4)
    end
  end
end
