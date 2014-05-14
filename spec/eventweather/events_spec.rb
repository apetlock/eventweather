require 'eventweather/events'
require 'eventweather/event'

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
    @events = Eventweather::Events.new(94555)
  end

  describe 'all' do
    it 'should return an array of events' do
      @events.all.is_a?(Array).should be_true
      @events.all.first.is_a?(Eventweather::Event).should be_true
      @events.all.size.should eq 3
    end
  end
end