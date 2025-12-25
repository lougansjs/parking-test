module Services
  class CheckInVehicle
    def initialize(repository: Repositories::ParkingRecordRepository.new)
      @repository = repository
    end

    def call(plate:)
      plate_vo = Domain::ValueObjects::Plate.new(plate)

      if @repository.find_open_by_plate(plate_vo.to_s)
        raise StandardError, "Vehicle already parked"
      end

      @repository.create(plate: plate_vo.to_s)
    end
  end
end
