require_relative 'api/eventbrite'
require_relative 'event'

module Eventweather
  
  # This is a wrapper for the weather.
  class Events

    attr_reader :zip

    def initialize(zip)
      @zip = zip
      @events_api = Eventweather::API::Eventbrite.new(@zip)
    end

    def all
      @events_api.events.map { |event| Event.new(event) }
    end
  end
end