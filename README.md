# Bless [![Build Status](https://secure.travis-ci.org/DevL/bless.png)](http://travis-ci.org/DevL/bless) [![Code Climate](https://codeclimate.com/github/DevL/bless.png)](https://codeclimate.com/github/DevL/bless) ![Gem version](https://badge.fury.io/rb/bless.png) 

Miss Perl? Ever wished Ruby was more like it? Me neither, but that's no excuse for going nuts and hack together some insane code that Perlifies Ruby.

There's no excuse for using it in production though.

## Installation

Add this line to your application's Gemfile:

    gem 'bless'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bless

## Usage

Using bless is simplicity itself. Or was it idiocy? Nevermind, bless your followers by uttering the following. Preferably followed by a prayer that your code will not be seen by anyone. Ever.

```ruby
  blessed_object = bless(Object.new, String)
  blessed_object.instance_of?(String) # => true
```

Now, the proverbial example usage of bless in Perl would operate in conjunction with the `my` keyword. However, implementing support for that proved to be somewhat less than straightforward. To make a long story short, setting a local variable from an eval AND retaining that local variable beyond the scope of the eval is simply not possible in Ruby\*.

\* Until we come up with the idea of hacking Rubinius into submission. Hopefully we'll never think of that.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b I-say-we-take-off-and-nuke-it-from-orbit`)
3. Commit your changes (`git commit -am 'It is the only way to make sure!'`)
4. Push to the branch (`git push origin I-say-we-take-off-and-nuke-it-from-orbit`)
5. Create new Pull Request
