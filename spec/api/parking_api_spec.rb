require 'spec_helper'

RSpec.describe Parking::API::V1::Parking do
  include Rack::Test::Methods

  def app
    Parking::API::Base
  end

  describe 'POST /api/v1/parking' do
    context 'with valid params' do
      it 'returns 201 and creates record' do
        post '/api/v1/parking', { plate: 'ABC-1234' }

        expect(last_response.status).to eq(201)
        json = JSON.parse(last_response.body)
        expect(json['plate']).to eq('ABC-1234')
        expect(json['id']).to be_present
      end
    end

    context 'with invalid params' do
      it 'returns 400 for invalid plate format' do
        post '/api/v1/parking', { plate: 'invalid' }
        expect(last_response.status).to eq(422)
      end

      it 'returns 422 if already parked' do
        post '/api/v1/parking', { plate: 'ABC-1234' }
        post '/api/v1/parking', { plate: 'ABC-1234' }
        expect(last_response.status).to eq(422)
      end
    end
  end

  describe 'PUT /api/v1/parking/:id/pay' do
    let!(:record) { Services::CheckInVehicle.new.call(plate: 'ABC-1234') }

    it 'returns 204 and marks as paid' do
      put "/api/v1/parking/#{record.id}/pay"
      expect(last_response.status).to eq(204)

      updated = Repositories::ParkingRecordRepository.new.find_by_id(record.id)
      expect(updated.paid).to be true
    end
  end

  describe 'PUT /api/v1/parking/:id/out' do
    let!(:record) { Services::CheckInVehicle.new.call(plate: 'ABC-1234') }

    it 'returns 204 and marks as out if paid' do
      Services::RegisterPayment.new.call(id: record.id)
      
      put "/api/v1/parking/#{record.id}/out"
      expect(last_response.status).to eq(204)
      
      updated = Repositories::ParkingRecordRepository.new.find_by_id(record.id)
      expect(updated.exit_time).to be_present
    end

    it 'returns 422 if not paid' do
      put "/api/v1/parking/#{record.id}/out"
      expect(last_response.status).to eq(422)
      expect(JSON.parse(last_response.body)['error']).to include('Payment required')
    end
  end

  describe 'GET /api/v1/parking/:plate' do
    it 'returns history' do
      record = Services::CheckInVehicle.new.call(plate: 'ABC-1234')
      
      get '/api/v1/parking/ABC-1234'
      expect(last_response.status).to eq(200)
      
      json = JSON.parse(last_response.body)
      expect(json).to be_an(Array)
      expect(json.first['id']).to eq(record.id.to_s)
    end
  end
end
