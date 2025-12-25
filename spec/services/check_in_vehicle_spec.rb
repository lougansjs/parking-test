require 'spec_helper'

RSpec.describe Services::CheckInVehicle do
  let(:repository) { instance_double(Repositories::ParkingRecordRepository) }
  let(:service) { described_class.new(repository: repository) }

  describe '#call' do
    it 'creates a parking record' do
      expect(repository).to receive(:find_open_by_plate).with('ABC-1234').and_return(nil)
      expect(repository).to receive(:create).with(plate: 'ABC-1234')
      
      service.call(plate: 'ABC-1234')
    end

    it 'raises error if vehicle already parked' do
      expect(repository).to receive(:find_open_by_plate).with('ABC-1234').and_return(double)
      
      expect { service.call(plate: 'ABC-1234') }.to raise_error(StandardError, "Vehicle already parked")
    end

    it 'validates plate format' do
      expect { service.call(plate: 'invalid') }.to raise_error(ArgumentError)
    end
  end
end
