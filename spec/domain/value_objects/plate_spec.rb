require 'spec_helper'

RSpec.describe Domain::ValueObjects::Plate do
  describe '#initialize' do
    context 'with valid format' do
      it 'creates a plate' do
        plate = described_class.new('ABC-1234')
        expect(plate.to_s).to eq('ABC-1234')
      end

      it 'normalizes input' do
        plate = described_class.new('  abc-1234  ')
        expect(plate.to_s).to eq('ABC-1234')
      end
    end

    context 'with invalid format' do
      it 'raises error for wrong format' do
        expect { described_class.new('ABC1234') }.to raise_error(ArgumentError)
      end

      it 'raises error for empty string' do
        expect { described_class.new('') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#==' do
    it 'returns true for same values' do
      plate1 = described_class.new('ABC-1234')
      plate2 = described_class.new('abc-1234')
      expect(plate1).to eq(plate2)
    end
  end
end
