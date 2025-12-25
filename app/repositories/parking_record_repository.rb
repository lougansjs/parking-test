module Repositories
  class ParkingRecordRepository
    def create(plate:, entry_time: Time.now.utc)
      Models::ParkingRecord.create!(
        plate: plate,
        entry_time: entry_time
      )
    end

    def find_open_by_plate(plate)
      Models::ParkingRecord.where(plate: plate, exit_time: nil).first
    end

    def find_by_id(id)
      Models::ParkingRecord.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end

    def find_history_by_plate(plate)
      Models::ParkingRecord.where(plate: plate).order(entry_time: :desc).to_a
    end

    def update(record)
      record.save!
    end
  end
end
