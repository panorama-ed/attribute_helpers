[![Code Climate](https://codeclimate.com/github/panorama-ed/attribute_helpers/badges/gpa.svg)](https://codeclimate.com/github/panorama-ed/attribute_helpers) [![Test Coverage](https://codeclimate.com/github/panorama-ed/attribute_helpers/badges/coverage.svg)](https://codeclimate.com/github/panorama-ed/attribute_helpers) [![Build Status](https://travis-ci.org/panorama-ed/attribute_helpers.svg)](https://travis-ci.org/panorama-ed/attribute_helpers) [![Inline docs](http://inch-ci.org/github/panorama-ed/attribute_helpers.png)](http://inch-ci.org/github/panorama-ed/attribute_helpers) [![Gem Version](https://badge.fury.io/rb/attribute_helpers.svg)](http://badge.fury.io/rb/attribute_helpers)

# AttributeHelpers

Provides helper functionality for ruby classes that store various
database-unfriendly types as instance variables. It automatically serializes and
deserializes things like classes and symbols to interact easily with both the
database and your application code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "attribute_helpers"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attribute_helpers

## Usage

This gem exposes the `attr_symbol` and `attr_class` class methods, which when
called will wrap the related instance method to allow for better database
serialization.

```ruby
require "attribute_helpers"

class Vehicle < ActiveRecord::Base
  extend AttributeHelpers

  attr_class :manufacturer
  attr_symbol :status
end

car = Vehicle.new
car.manufacturer = Tesla # This is a class.
car.status = :parked
car.save!
car = car.reload # After a DB round-trip, typically these fields are strings.
car.manufacturer # Tesla (the class) rather than "Tesla" (the string)
car.status # :parked (the symbol) rather than "parked" (the string)

```

Note: while this gem was written to help with ActiveRecord
objects, it has **no dependencies** and works great with any database
backend (or none!). **You can extend it into pure Ruby classes just
fine!**

## Contributing

1. Fork it (https://github.com/panorama-ed/attribute_helpers/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

**Make sure your changes have appropriate tests (`bundle exec rspec`)
and conform to the Rubocop style specified.** We use
[overcommit](https://github.com/causes/overcommit) to enforce good code.

## License

AttributeHelpers is released under the
[MIT License](https://github.com/panorama-ed/attribute_helpers/blob/master/LICENSE.txt).
