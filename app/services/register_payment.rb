module Services
  class RegisterPayment
    def initialize(repository: Repositories::ParkingRecordRepository.new)
      @repository = repository
    end

    def call(id:)
      record = @repository.find_by_id(id)
      raise Parking::Errors::NotFoundError, "Parking record not found" unless record

      raise Parking::Errors::BusinessError, "Parking record already paid" if record.paid

      record.paid = true
      record.payment_time = Time.now.utc
      @repository.update(record)
    end
  end
end
