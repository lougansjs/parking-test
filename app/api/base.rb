module Parking
  module API
    class Base < Grape::API
      format :json
      prefix :api

      rescue_from :all do |e|
        error!({ error: e.message }, 500)
      end

      rescue_from Mongoid::Errors::DocumentNotFound, Parking::Errors::NotFoundError do |e|
        error!({ error: "Record not found" }, 404)
      end

      rescue_from ArgumentError, Parking::Errors::BusinessError do |e|
        error!({ error: e.message }, 422)
      end

      mount Parking::API::V1::Parking
    end
  end
end
