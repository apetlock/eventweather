require 'curb'
require 'json'
require 'yaml'

module Eventweather
  module API
    class Wunderground

      API_URL = 'http://api.wunderground.com/api/'
      API_KEY = YAML.load(File.read(File.join(File.dirname(__FILE__), '../../../config/keys.yml')))['keys']['wunderground']

      def initialize(options)
        if options[:zip]
          @zip = options[:zip]
          @conditions_data = conditions_for_zip(@zip)
          @forecast_data = forecast_for_zip(@zip)
        elsif options[:latitude] #assume :longitude too
          @latitude = options[:latitude]
          @longitude = options[:longitude]
          @conditions_data = conditions_for_coordinates(@latitude, @longitude)
          @forecast_data = forecast_for_coordinates(@latitude, @longitude)
        else
          raise
        end            
      end

      def location_name
        display_location['full']
      end

      def fahrenheit
        current_observation['temp_f']
      end

      def celsius
        current_observation['temp_c']
      end

      def description
        current_observation['weather']
      end

      def humidity_percent
        current_observation['relative_humidity'].gsub('%', '').to_f / 100
      end

      def high_for_day(date, deg = :f)
        day = forecast_days.find { |day| day.date == date }
        day ? day.high(deg) : 'Unavailable-'
      end

      def low_for_day(date, deg = :f)
        day = forecast_days.find { |day| day.date == date }
        day ? day.low(deg) : 'Unavailable-'
      end

      private

      def forecast_days
        @forecast_data['forecast']['simpleforecast']['forecastday'].map do |raw_day|
          ForecastDay.new(raw_day)
        end
      end

      def current_observation
        @conditions_data['current_observation']
      end

      def display_location
        current_observation['display_location']
      end

      def conditions_for_coordinates(lat, long)
        conditions("#{API_URL}#{API_KEY}/conditions/q/#{lat},#{long}.json")
      end

      def conditions_for_zip(zip)
        conditions("#{API_URL}#{API_KEY}/conditions/q/#{zip}.json")
      end

      def conditions(conditions_path)
        response = Curl.get(conditions_path) do |curl|
          curl.headers['Accept'] = 'application/json'
        end
        JSON.parse(response.body_str)
      end

      def forecast_for_coordinates(lat, long)
        forecast("#{API_URL}#{API_KEY}/forecast/q/#{lat},#{long}.json")
      end

      def forecast_for_zip(zip)
        forecast("#{API_URL}#{API_KEY}/forecast/q/#{zip}.json")        
      end

      # I could combine this under one universal 'get' method,
      # but I want them separate for testing right now, since I'm spending
      # too much time on this already. :)
      #
      def forecast(forecast_path)
        response = Curl.get(forecast_path) do |curl|
          curl.headers['Accept'] = 'application/json'
        end
        JSON.parse(response.body_str)
      end
    end

    class ForecastDay
      def initialize(day_data)
        @day_data = day_data
      end

      def date
        date = @day_data['date']
        year = date['year']
        month = date['month']
        day = date['day']
        Date.parse("#{year}-#{month}-#{day}")
      end

      def high(deg = :f)
        if deg == :c
          @day_data['high']['celsius'].to_f
        else
          @day_data['high']['fahrenheit'].to_f
        end
      end

      def low(deg = :f)
        if deg == :c
          @day_data['low']['celsius'].to_f
        else
          @day_data['low']['fahrenheit'].to_f
        end
      end
    end
  end
end
