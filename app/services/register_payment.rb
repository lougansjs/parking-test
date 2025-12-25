module Services
  class RegisterPayment
    def initialize(repository: Repositories::ParkingRecordRepository.new)
      @repository = repository
    end

    def call(id:)
      record = @repository.find_by_id(id)
      raise StandardError, "Parking record not found" unless record

      record.paid = true
      record.payment_time = Time.now.utc
      @repository.update(record)
    end
  end
end
