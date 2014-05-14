# Eventweather

A simple command line utility for getting events and weather.

## Installation

Unpack and then execute:

    $ bundle install

Then setup config/keys.yml

    keys:
        eventbrite: <API_TOKEN>
        wunderground: <API_KEY>

## Usage

    eventweather --zipcode 94304

For a list of options:

    eventweather --help
