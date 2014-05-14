require 'curb'
require 'json'
require 'date'
require 'yaml'

module Eventweather
  module API
    class Eventbrite

      API_URL = 'https://www.eventbriteapi.com/v3/events/search/?q='
      API_TOKEN = YAML.load(File.read(File.join(File.dirname(__FILE__), '../../../config/keys.yml')))['keys']['eventbrite']

      def initialize(zip)
        @zip = zip
      end

      def events
        data.map { |event_data| EventbriteEvent.new(event_data) }
      end

      private

      # This is done in a central point to call data so that the API
      # isn't called for each and every call to the object.
      #
      def data
        @raw_data || @raw_data = events_for_zip(@zip)
      end

      def events_for_zip(zip)
        conditions_path = "#{API_URL}#{zip}"
        response = Curl.get(conditions_path) do |curl|
          curl.headers['Accept'] = 'application/json'
          curl.headers['Authorization'] = "Bearer #{API_TOKEN}"
        end
        JSON.parse(response.body_str)['events']
      end
    end

    # As long as the API-specific event returns the standard
    # methods expected by Eventweather::Event, everything is good to go.
    #
    class EventbriteEvent

      def initialize(event_json)
        @raw_event = event_json
      end

      def name
        @raw_event['name']['text']
      end

      def description
        @raw_event['description']['text']
      end

      def location_name
        venue['name']
      end

      def street
        venue['address']['address_1']
      end

      def city
        venue['address']['city']
      end

      def state
        venue['address']['region']
      end

      def latitude
        venue['latitude'].to_f
      end

      def longitude
        venue['longitude'].to_f
      end

      def time
        DateTime.iso8601(@raw_event['start']['local'])
      end

      private

      def venue
        @raw_event['venue']
      end
    end
  end
end
