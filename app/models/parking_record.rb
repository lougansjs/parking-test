module Models
  class ParkingRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :plate, type: String
    field :entry_time, type: Time
    field :exit_time, type: Time
    field :paid, type: Boolean, default: false
    field :payment_time, type: Time

    index({ plate: 1 })
    index({ plate: 1, exit_time: 1 })

    validates :plate, presence: true
    validates :entry_time, presence: true

    def duration_in_minutes
      return 0 unless entry_time

      end_time = exit_time || Time.now.utc
      ((end_time - entry_time) / 60).to_i
    end
  end
end
