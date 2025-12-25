require 'spec_helper'

RSpec.describe Services::GetVehicleHistory do
  let(:repository) { instance_double(Repositories::ParkingRecordRepository) }
  let(:service) { described_class.new(repository: repository) }

  describe '#call' do
    it 'returns history for plate' do
      expect(repository).to receive(:find_history_by_plate).with('ABC-1234').and_return([])

      service.call(plate: 'ABC-1234')
    end

    it 'validates plate format' do
      expect { service.call(plate: 'invalid') }.to raise_error(ArgumentError)
    end
  end
end
