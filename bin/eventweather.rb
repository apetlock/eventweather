#!/usr/bin/env ruby

require_relative '../lib/eventweather'

@zip = nil
@temp = :f
@num = 3

def show_help
  puts
  puts "-z, --zipcode [zipcode]"
  puts "    The zipcode you'd like events from."
  puts
  puts "--temp [C,F] Celsius or Fahrenheit"
  puts
  puts "-n [num] Number of entries to return"
  puts
  puts "--help This text."
  puts
end

while ARGV.size > 0
  option = ARGV.shift
  case option
  when '-z', '--zipcode'
    @zip = ARGV.shift
  when '--temp'
    @temp = ARGV.shift == 'C' ? :c : :f
  when '-n'
    @num = ARGV.shift
  else
    show_help
    exit 0
  end
end

if @zip.nil?
  puts "Need a zip code!"
  exit 0
end

@eventweathers = Eventweather.get_events_and_weather_for_zip(@zip, @num, @temp)

@eventweathers.each do |ew|
  event = ew[0]
  weather = ew[1]

  puts
  puts event.time.strftime('%A, %B %e, %Y at %l:%M%P')
  puts "#{event.name} @ #{event.location_name}"
  puts event.address
  puts "High: #{weather.high_for_day(event.time.to_date)}#{@temp.to_s}/Low: #{weather.low_for_day(event.time.to_date)}#{@temp.to_s}, #{weather.description}"
end
puts
