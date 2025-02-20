require 'spec_helper'
require_relative '../../lib/invaders/pattern'
require_relative '../../lib/invaders/matrix'

RSpec.describe Invaders::Pattern do
  let(:matrix_data) do
    [
      [0, 1],
      [1, 0]
    ]
  end

  let(:matrix) { Invaders::Matrix.new(matrix_data) }

  subject(:pattern) { described_class.new(matrix) }

  describe '#rotations' do
    it 'generates all four rotations' do
      expect(pattern.rotations.size).to eq(4)
    end

    it 'includes original pattern' do
      expect(pattern.rotations.first).to eq(matrix)
    end
  end
end
