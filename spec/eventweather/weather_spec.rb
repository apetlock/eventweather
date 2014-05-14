require 'eventweather/weather'

# Mocking out the weather API to use the fixture instead
module Eventweather
  module API
    class Wunderground
      private
      def conditions(path)
        file_location = "#{File.dirname(__FILE__)}"
        JSON.parse(File.read("#{file_location}/fixtures/conditions.json"))
      end
      def forecast(path)
        file_location = "#{File.dirname(__FILE__)}"
        JSON.parse(File.read("#{file_location}/fixtures/forecast.json"))
      end
    end
  end
end

describe Eventweather::Weather do

  describe 'conditions' do
    describe 'zip code' do
      before(:all) do
        @weather = Eventweather::Weather.new(zip: 94555)
      end

      it 'should return location name' do
        @weather.location_name.should eq 'Fremont, CA'
      end

      it 'should default temperature in fahrenheit' do
        @weather.temp.should eq 91.4
      end

      it 'should return temperature in celsius' do
        @weather.deg = :c
        @weather.temp.should eq 33.0
      end

      it 'should report degrees as a float' do
        @weather.temp.class.should eq Float
      end

      it 'should return humidity' do
        @weather.humidity.should eq 0.16
      end

      it 'should return weather description' do
        @weather.description.should eq 'Clear'
      end
    end

    describe 'coordinates' do
      before(:all) do
        # Same data is returned, just want to test the arguments passing
        @weather = Eventweather::Weather.new(latitude: 0, longitude: 0)
      end

      it 'should return location name' do
        @weather.location_name.should eq 'Fremont, CA'
      end
    end
  end

  describe 'forecast' do
    before(:all) do
      @weather = Eventweather::Weather.new(zip: 94555)
    end

    it 'should return high' do
      @weather.high_for_day(Date.parse("2014-05-13")).should eq 90.0
    end

    it 'should return low' do
      @weather.low_for_day(Date.parse("2014-05-13")).should eq 62.0
    end
  end
end