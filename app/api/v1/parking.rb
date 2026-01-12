module Parking
  module API
    module V1
      class Parking < Grape::API
        version 'v1', using: :path
        resource :parking do

          desc 'Check-in a vehicle'
          params do
            requires :plate, type: String, desc: 'Vehicle plate'
          end
          post do
            service = Services::CheckInVehicle.new
            record = service.call(plate: params[:plate])
            { id: record.id.to_s, plate: record.plate, entry_time: record.entry_time }
          end

          route_param :id do
            desc 'Pay for parking'
            put :pay do
              service = Services::RegisterPayment.new
              service.call(id: params[:id])
              status 204
            end

            desc 'Check-out a vehicle'
            put :out do
              service = Services::CheckOutVehicle.new
              service.call(id: params[:id])
              status 204
            end
          end

          desc 'Get parking history for a plate'
          params do
            requires :plate, type: String, desc: 'Vehicle plate'
          end
          get ':plate' do
            service = Services::GetVehicleHistory.new
            history = service.call(plate: params[:plate])
            history.map do |record|
              {
                id: record.id.to_s,
                time: "#{record.duration_in_minutes} minutes",
                paid: record.paid,
                left: !record.exit_time.nil?
              }
            end
          end
        end
      end
    end
  end
end
