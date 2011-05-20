require 'data_miner'

module BrighterPlanet
  module Flight
    module Data
      def self.included(base)
        base.data_miner do
          schema do
            date    'date'
            integer 'segments_per_trip'
            string  'origin_airport_iata_code'
            string  'destination_airport_iata_code'
            string  'aircraft_icao_code'
            string  'airline_name'
            integer 'trips'
            float   'load_factor'
            integer 'seats_estimate'
            string  'fuel_name'
            float   'distance_estimate'
            string  'distance_class_name'
            string  'seat_class_name'
            string  'flight_segment_row_hash'
          end
          
          process "pull orphans" do
            FlightSegment.run_data_miner!
          end
          
          process :run_data_miner_on_belongs_to_associations
        end
      end
    end
  end
end
