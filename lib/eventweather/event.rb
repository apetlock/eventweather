module Eventweather
  
  # This Event class is basically a decorator for the API-specific
  # Event class. This allows any API to be used basically and then I can
  # elaborate on it with other methods, such as string outputs, etc.
  #
  class Event

    def initialize(api_event)
      @api_event = api_event
    end

    def name
      @api_event.name
    end

    def description
      @api_event.description
    end

    def location_name
      @api_event.location_name
    end

    def street
      @api_event.street
    end

    def city
      @api_event.city
    end

    def state
      @api_event.state
    end

    def address
      "#{street}, #{city}, #{state}"
    end

    def latitude
      @api_event.latitude
    end

    def longitude
      @api_event.longitude
    end

    def time
      @api_event.time
    end

    def date_string
      time.strftime('%b %-d')
    end

    def time_string
      time.strftime('%l:%M%P')
    end
  end
end