module Services
  class GetVehicleHistory
    def initialize(repository: Repositories::ParkingRecordRepository.new)
      @repository = repository
    end

    def call(plate:)
      plate_vo = Domain::ValueObjects::Plate.new(plate)
      history = @repository.find_history_by_plate(plate_vo.to_s)

      raise Parking::Errors::NotFoundError, "Parking record not found" if history.empty?

      history
    end
  end
end
