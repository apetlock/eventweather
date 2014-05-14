require_relative 'api/wunderground'

module Eventweather
  
  # This is a wrapper for the weather.
  class Weather

    # for tests
    attr_accessor :deg

    def initialize(options)
      if options[:zip]
        @zip = options[:zip]
        @weather_api = Eventweather::API::Wunderground.new(zip: @zip)
      elsif options[:latitude] #assume :longitude too
        @latitude = options[:latitude]
        @longitude = options[:longitude]
        @weather_api = Eventweather::API::Wunderground.new(latitude: @latitude, longitude: @longitude)
      else
        raise
      end
      if options[:deg]
        @deg = options[:deg]
      else
        @deg = :f
      end
    end

    def location_name
      @weather_api.location_name
    end

    def temp
      if @deg == :c
        @weather_api.celsius
      else
        @weather_api.fahrenheit
      end
    end

    def humidity
      @weather_api.humidity_percent
    end

    def description
      @weather_api.description
    end

    def high_for_day(date)
      @weather_api.high_for_day(date, @deg)
    end

    def low_for_day(date)
      @weather_api.low_for_day(date, @deg)
    end
  end
end