module Services
  class CheckOutVehicle
    def initialize(repository: Repositories::ParkingRecordRepository.new)
      @repository = repository
    end

    def call(id:)
      record = @repository.find_by_id(id)
      raise StandardError, "Parking record not found" unless record

      unless record.paid
        raise StandardError, "Payment required before checkout"
      end

      if record.exit_time
        raise StandardError, "Vehicle already checked out"
      end

      record.exit_time = Time.now.utc
      @repository.update(record)
    end
  end
end
