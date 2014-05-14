require 'eventweather/events'

# Mocking out the events API to use the fixture instead
module Eventweather
  module API
    class Eventbrite
      private
      def events_for_zip(zip)
        file_location = "#{File.dirname(__FILE__)}"
        JSON.parse(File.read("#{file_location}/fixtures/eventbrite_query.json"))['events']
      end
    end
  end
end

describe Eventweather::Events do

  before(:all) do
    @event = Eventweather::Events.new(94555).all.first
  end

  it 'should return event name' do
    @event.name.should eq 'Happiness Seminar / Meditation Mixer'
  end

  it 'should return event location name' do
    @event.location_name.should eq 'Fremont Centre'
  end

  it 'should return event address' do
    @event.address.should eq '555 Mowry Ave, Fremont, CA'
  end

  it 'should return event date string' do
    @event.date_string.should eq 'May 14'
  end

  it 'should return event time string' do
    @event.time_string.should eq ' 7:00pm'
  end

  it 'should return latitude' do
    @event.latitude.should eq 37.5681196
  end

  it 'should return longitude' do
    @event.longitude.should eq -121.973074
  end
end
