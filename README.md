# Watizzle [![Build Status](https://travis-ci.org/p0deje/watizzle.svg?branch=master)](https://travis-ci.org/p0deje/watizzle) [![Gem Version](https://badge.fury.io/rb/watizzle.svg)](http://badge.fury.io/rb/watizzle)

[Sizzle](http://sizzlejs.com)-based locator engine for [Watir](https://github.com/watir/watir).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watizzle'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install watizzle
```

## Usage

Require after Watir, the rest should just work.

```ruby
require 'watir'
require 'watizzle'
```

## Comparison with default Watir locators

In most cases watizzle works slightly slower than default Watir locator,
mainly because it doesn't use selenium-webdriver optimized `find_element` and
relies on `#execute_script`. However, the performance improves a lot when working
with regular expression selectors.

Let's say you want to find all the links from Google results page that include `watir`:

```ruby
browser.as(text: /watir/).to_a
```

The following line executes for more than 1 second with default Watir.
With watizzle, it's executed for less than 0.1 second, which is 10x faster!

## Limitations

Some watir locators cannot be reimplemented with watizzle. In such cases,
it falls back to watir, so you should be able to migrate pretty easily.
The only issue that may occur is the usage of complicated regular expressions.
For now, watizzle simply uses your Ruby regexp in JavaScript, ignoring the cases
when it's incompatible. If you see any issue with regexp selectors, make sure
your regexp is compatible with JavaScript regexp engine.

## Development

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Specs

Run all specs:

```bash
$ bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/p0deje/watizzle.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
