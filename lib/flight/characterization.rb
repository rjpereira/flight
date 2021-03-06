module BrighterPlanet
  module Flight
    module Characterization
      def self.included(base)
        base.characterize do
          has :date
          has :segments_per_trip
          has :origin_airport
          has :destination_airport
          has :aircraft
          has :airline
          has :trips
          has :load_factor
          has :seats
          has :fuel
          has :distance_estimate, :measures => Measurement::BigLength
          has :distance_class
          has :seat_class
          has :flight_segment_row_hash
        end
      end
    end
  end
end
