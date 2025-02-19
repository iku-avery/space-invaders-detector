require 'spec_helper'
require_relative '../../lib/invaders/matrix'
require_relative '../../lib/invaders/parser'

RSpec.describe Invaders::Parser do
  subject(:parser) { described_class.new(cell_char: cell_char, empty_cell_char: empty_cell_char) }

  let(:cell_char) { 'o' }
  let(:empty_cell_char) { '-' }

  describe '#initialize' do
    context 'with invalid characters' do
      it 'raises error when characters are the same' do
        expect { described_class.new(cell_char: 'x', empty_cell_char: 'x') }
          .to raise_error(ArgumentError, 'Characters must be different')
      end

      it 'raises error when characters are not single characters' do
        expect { described_class.new(cell_char: 'xx', empty_cell_char: '-') }
          .to raise_error(ArgumentError, 'Characters must be single characters')
      end
    end
  end

  describe '#parse' do
    context 'with valid input' do
      let(:invader) do
        <<~TEXT
          oo---oo
          ---o---
          --ooo--
        TEXT
      end

      let(:expected_data) do
        [
          [1, 1, 0, 0, 0, 1, 1],
          [0, 0, 0, 1, 0, 0, 0],
          [0, 0, 1, 1, 1, 0, 0]
        ]
      end

      it 'parses data correctly' do
        expect(parser.parse(invader)).to eq(expected_data)
      end

      context 'with custom characters' do
        let(:cell_char) { '*' }
        let(:empty_cell_char) { '.' }

        let(:invader) do
          <<~TEXT
            **...**
            ...*...
            ..***..
          TEXT
        end

        it 'parses with custom characters' do
          expect(parser.parse(invader)).to eq(expected_data)
        end
      end
    end

    context 'with invalid input' do
      it 'raises error when input is nil' do
        expect { parser.parse(nil) }
          .to raise_error(Invaders::InvalidDataError, 'Input data cannot be nil')
      end

      it 'raises error when input is not a string' do
        expect { parser.parse([]) }
          .to raise_error(Invaders::InvalidDataError, 'Input data must be a string')
      end

      it 'raises error when input has inconsistent line lengths' do
        expect { parser.parse("oo-\n-----\n") }
          .to raise_error(Invaders::InvalidDataError, 'All lines must have the same length')
      end

      it 'raises error when input is empty' do
        expect { parser.parse('') }
          .to raise_error(Invaders::InvalidDataError, 'No valid lines found in input')
      end
    end
  end
end
