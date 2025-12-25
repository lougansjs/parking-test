require 'spec_helper'

RSpec.describe Services::CheckOutVehicle do
  let(:repository) { instance_double(Repositories::ParkingRecordRepository) }
  let(:service) { described_class.new(repository: repository) }
  let(:record) { instance_double(Models::ParkingRecord, paid: true, exit_time: nil) }

  describe '#call' do
    it 'marks record as checked out' do
      expect(repository).to receive(:find_by_id).with('some-id').and_return(record)
      expect(record).to receive(:exit_time=).with(kind_of(Time))
      expect(repository).to receive(:update).with(record)

      service.call(id: 'some-id')
    end

    it 'raises error if record not found' do
      expect(repository).to receive(:find_by_id).with('some-id').and_return(nil)

      expect { service.call(id: 'some-id') }.to raise_error(StandardError, "Parking record not found")
    end

    it 'raises error if not paid' do
      allow(record).to receive(:paid).and_return(false)
      expect(repository).to receive(:find_by_id).with('some-id').and_return(record)

      expect { service.call(id: 'some-id') }.to raise_error(StandardError, "Payment required before checkout")
    end

    it 'raises error if already checked out' do
      allow(record).to receive(:exit_time).and_return(Time.now)
      expect(repository).to receive(:find_by_id).with('some-id').and_return(record)

      expect { service.call(id: 'some-id') }.to raise_error(StandardError, "Vehicle already checked out")
    end
  end
end
