require 'spec_helper'

RSpec.describe Repositories::ParkingRecordRepository do
  let(:repository) { described_class.new }

  describe '#create' do
    it 'creates a parking record' do
      record = repository.create(plate: 'ABC-1234')
      expect(record).to be_persisted
      expect(record.plate).to eq('ABC-1234')
      expect(record.entry_time).to be_present
    end
  end

  describe '#find_open_by_plate' do
    it 'returns open record for plate' do
      repository.create(plate: 'ABC-1234')
      record = repository.find_open_by_plate('ABC-1234')
      expect(record).to be_present
    end

    it 'returns nil if no open record' do
      Models::ParkingRecord.create!(plate: 'ABC-1234', entry_time: Time.now, exit_time: Time.now)
      record = repository.find_open_by_plate('ABC-1234')
      expect(record).to be_nil
    end
  end

  describe '#find_history_by_plate' do
    it 'returns history ordered by entry_time desc' do
      record1 = repository.create(plate: 'ABC-1234', entry_time: 2.hours.ago)
      record2 = repository.create(plate: 'ABC-1234', entry_time: 1.hour.ago)
      
      history = repository.find_history_by_plate('ABC-1234')
      expect(history.map(&:id)).to eq([record2.id, record1.id])
    end
  end
end
