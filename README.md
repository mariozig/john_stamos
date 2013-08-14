# JohnStamos 

The greasiest Pinterest client. JohnStamos exposes an interface you can use to query Pinterest for data about individual Pins, Pinners and Pin searches.  Have mercy.

[![Build Status](https://travis-ci.org/mariozig/john_stamos.png?branch=master)](https://travis-ci.org/mariozig/john_stamos)

## Installation

Add this line to your application's Gemfile:

    gem 'john_stamos'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install john_stamos

Or finally, if none of that stuff applies to you, do what it takes to install the gem and add this to your script:

    require 'john_stamos'

## Usage

### Searching for Pins

Here's a typical use-case: You want to search Pinterest for some pins.  Once you have those pins, you want to access information about each individual pin as well as information about the person who pinned it.

    client = JohnStamos::Client.new
    
    # Search for some sweet Pins of "pallet gardens"
    pins = client.search_pins("pallet gardens", limit: 10)
    # Returns an Array of Pin objects
    
    # The first Pin will be fun to investigate.
    first_pallet_garden_pin = pallet_search.first
    
    # Print some info about the first Pin description
    puts first_pallet_garden_pin.description
    # => "A cool pallet garden"
    
    # the full sized image
    puts first_pallet_garden_pin.image
    # => "http://media-cache-ak0.pinimg.com/originals....whatever.jpg"
    
    # Pinterest's ID for this Pin
    puts first_pallet_garden_pin.id
    # => "123456789"
    
    # URL to the Pin
    puts first_pallet_garden_pin.url
    # => "http://pinterest.com/pin/123456789"
    
    # We can even get at the user who Pinned this Pin
    first_pallet_garden_pin.pinner
    
    # Print the Pinner's full name
    puts first_pallet_garden_pin.pinner.full_name
    # => "Little Bobby Tables"

### Using the Client

The Client is the single entry point into all things JohnStamos. 

    # Create a new Client
    client = JohnStamos::Client.new
    
    # The Client also supports using a proxy
    client_with_proxy = JohnStamos::Client.new(proxy: 'http://127.1.1.1:4747')
    
    # Note: If you're hosted on Heroku, you will want to use a proxy.


### Accessing Individual Pin Data

There are times you might want to access an individual Pin's information.  All you need is the ID assigned to the Pin by Pinterest to get going.

    client = JohnStamos::Client.new
    
    # Get a magnificent Pin using it's ID
    perfect_strangers_pin = client.pin(161848180328631541)
    
    puts perfect_strangers_pin.description
    # => "Balki Bartokomous and Cousin Larry!!! PERFECT STRANGERS...loved that show!"
    
    puts perfect_strangers_pin.image
    # => "http://media-cache-ec0.pinimg.com/originals/4b/10/d3/4b10d3bd1c172c52934eb2d79ff0031f.jpg"
    
    # If you didn't look at that image above, please do it before reading further
    
    puts perfect_strangers_pin.url
    # => "http://pinterest.com/pin/161848180328631541/"
    
    puts perfect_strangers_pin.repin_count
    # => 1

### Accessing Pinner Data

You can also query Pinterest for information about specific Pinners. Just pass in the Pinner's user name and you will be good to go.

    client = JohnStamos::Client.new
    
    # Get Michelle Obama's account
    michelle_obama = client.pinner("michelleobama")
    
    # Print some of the Pinner's information
    puts michelle_obama.last_name
    # => "Obama"
    
    puts michelle_obama.first_name
    # => "Michelle"
    
    puts michelle_obama.pin_count
    # => "81"
    
    puts michelle_obama.website_url
    # => "http://www.barackobama.com"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Notes

- Currently tested against [Ruby 2.0 only](https://github.com/mariozig/john_stamos/blob/master/.travis.yml).
- If you want to run tests locally I suggest you delete the [VCR cassettes](https://github.com/mariozig/john_stamos/tree/master/spec/support/vcr_cassettes) and start from scratch.  Pinterest changes OFTEN.
