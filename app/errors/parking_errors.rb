module Parking
  module Errors
    class BusinessError < StandardError; end
    class NotFoundError < StandardError; end
  end
end
