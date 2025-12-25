module Domain
  module ValueObjects
    class Plate
      attr_reader :value

      FORMAT_REGEX = /\A[A-Z]{3}-\d{4}\z/

      def initialize(value)
        @value = normalize(value)
        validate!
      end

      def to_s
        @value
      end

      def ==(other)
        other.is_a?(Plate) && value == other.value
      end

      private

      def normalize(value)
        value.to_s.strip.upcase
      end

      def validate!
        unless @value.match?(FORMAT_REGEX)
          raise ArgumentError, "Invalid plate format. Must be AAA-0000."
        end
      end
    end
  end
end
