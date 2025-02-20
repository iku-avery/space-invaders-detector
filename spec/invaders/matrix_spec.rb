require 'spec_helper'
require_relative '../../lib/invaders/matrix'
require_relative '../../lib/invaders/parser'

describe Invaders::Matrix do
  let(:invader) do
    <<~TEXT
      oo---oo
      ---o---
      --ooo--
    TEXT
  end

  # 0 1 2 3 4 5 6   (x-coordinates columns)
  # 0 o o - - - o o   (y = row 0)
  # 1 - - - o - - -   (y = row 1)
  # 2 - - o o o - -   (y = row 2)


  let(:expected_data) do
    [
      [1, 1, 0, 0, 0, 1, 1],
      [0, 0, 0, 1, 0, 0, 0],
      [0, 0, 1, 1, 1, 0, 0]
    ]
  end

  let(:expected_rows_count) { 3 }
  let(:expected_cols_count) { 7 }

  let(:full_cell) { 1 }
  let(:empty_cell) { 0 }
  let(:noise) { -1 }

  let(:parser) { Invaders::Parser.new }

  subject { described_class.new }

  describe "#x_size and #y_size" do
    it "returns correct dimensions" do
      subject.load_data(invader, parser)
      expect(subject.x_size).to eq(expected_cols_count)
      expect(subject.y_size).to eq(expected_rows_count)
    end
  end

  describe "#cell_at" do
    it "returns correct cell values" do
      subject.load_data(invader, parser)
      expect(subject.cell_at(0, 0)).to eq(full_cell)  # First 'o'
      expect(subject.cell_at(2, 0)).to eq(empty_cell)  # First '-'
    end
  end

  describe "#load_data with different symbols" do
    let(:new_invader) do
      <<~TEXT
        xx~~~xx
        ~~~x~~~
        ~~xxx~-
      TEXT
    end

    let(:new_expected_data) do
      [
        [1, 1, 0, 0, 0, 1, 1],
        [0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 0, -1]
      ]
    end

    it "can handle different symbols for cells" do
      new_parser = Invaders::Parser.new(cell_char: 'x', empty_cell_char: '~')
      subject.load_data(new_invader, new_parser)
      expect(subject.to_a).to eq(new_expected_data)
      expect(subject.cell_at(0, 0)).to eq(full_cell) # First 'x'
      expect(subject.cell_at(3, 0)).to eq(empty_cell) # First '~'
      expect(subject.cell_at(6, 2)).to eq(noise) # '-'
    end
  end

  describe "#load_data with one-liner matrix" do
    let(:one_liner_invader) do
      <<~TEXT
        ooooooo
      TEXT
    end

    let(:one_liner_expected_data) do
      [
        [1, 1, 1, 1, 1, 1, 1]
      ]
    end

    it "handles a one-liner matrix correctly" do
      subject.load_data(one_liner_invader, parser)
      expect(subject.to_a).to eq(one_liner_expected_data)
      expect(subject.x_size).to eq(expected_cols_count)
      expect(subject.y_size).to eq(1)
    end
  end

  describe "#cell_at" do
    let(:invader_with_noise) do
        <<~TEXT
          oo---oo
          ---o--x
          --ooo--
        TEXT
      end

    context "with valid coordinates" do
      it "returns correct cell values" do
        subject.load_data(invader_with_noise, parser)
        expect(subject.cell_at(0, 0)).to eq(full_cell)  # First 'o'
        expect(subject.cell_at(2, 0)).to eq(empty_cell)  # First '-'
        expect(subject.cell_at(2, 1)).to eq(empty_cell)  # This should be 0, not 1
        expect(subject.cell_at(4, 2)).to eq(full_cell)  # Last 'o' in last row
        expect(subject.cell_at(6, 1)).to eq(noise) # Last 'x' in the second row
      end
    end

    context "with invalid coordinates" do
      it "returns nil for out-of-bounds coordinates" do
        subject.load_data(invader, parser)
        expect(subject.cell_at(-1, 0)).to be_nil
        expect(subject.cell_at(0, -1)).to be_nil
        expect(subject.cell_at(7, 0)).to be_nil  # Outside right bound
        expect(subject.cell_at(0, 3)).to be_nil  # Outside bottom bound
      end
    end

    describe "#load_data with different symbols" do
      let(:new_invader) do
        <<~TEXT
          xx---xx
          ---x---
          --xxx--
        TEXT
      end

      let(:new_expected_data) do
        [
          [1, 1, 0, 0, 0, 1, 1],
          [0, 0, 0, 1, 0, 0, 0],
          [0, 0, 1, 1, 1, 0, 0]
        ]
      end

      it "can handle different symbols for cells" do
        new_parser = Invaders::Parser.new(cell_char: 'x', empty_cell_char: '-')
        subject.load_data(new_invader, new_parser)
        expect(subject.to_a).to eq(new_expected_data)
      end
    end

    describe "#add_line" do
      let(:new_line) { [0, 1, 0, 1, 0, 1, 0] }

      it "adds a new line correctly" do
        subject.load_data(invader, parser)
        expect(subject.x_size).to eq(expected_cols_count)
        expect(subject.y_size).to eq(expected_rows_count)

        subject.add_line(new_line)
        expect(subject.y_size).to eq(expected_rows_count + 1)
        expect(subject.cell_at(1, 3)).to eq(1)
        expect(subject.cell_at(3, 3)).to eq(1)
      end
    end
  end
end
