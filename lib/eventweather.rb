require_relative 'eventweather/version'
require_relative 'eventweather/weather'
require_relative 'eventweather/events'

module Eventweather

  # Just return an array with both an event and a weather object for that event.
  def self.get_events_and_weather_for_zip(zip, num = 3, deg = :f)
    @events = Eventweather::Events.new(zip).all[0, num.to_i]
    @weather_events = @events.map do |event|
      [event, Eventweather::Weather.new({latitude: event.latitude, longitude: event.longitude, deg: deg})]
    end
  end
end
