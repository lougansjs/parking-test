require 'spec_helper'

RSpec.describe Services::RegisterPayment do
  let(:repository) { instance_double(Repositories::ParkingRecordRepository) }
  let(:service) { described_class.new(repository: repository) }
  let(:record) { instance_double(Models::ParkingRecord, paid: false) }

  describe '#call' do
    it 'marks record as paid' do
      expect(repository).to receive(:find_by_id).with('some-id').and_return(record)
      expect(record).to receive(:paid=).with(true)
      expect(record).to receive(:payment_time=).with(kind_of(Time))
      expect(repository).to receive(:update).with(record)

      service.call(id: 'some-id')
    end

    it 'raises error if record not found' do
      expect(repository).to receive(:find_by_id).with('some-id').and_return(nil)

      expect { service.call(id: 'some-id') }.to raise_error(StandardError, "Parking record not found")
    end
  end
end
