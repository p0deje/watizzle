# Watizzle

[Sizzle](http://sizzlejs.com)-based locator engine for [watir-webdriver](https://github.com/watir/watir-webdriver).

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

Require after watir-webdriver, the rest should just work.

```ruby
require 'watir-webdriver'
require 'watizzle'
```

## Development

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Specs

Watizzle uses [watirspec](https://github.com/watir/watirspec) for testing, so
you should first fetch it:

```bash
$ git submodule init && git submodule update
```

Now, you can run all specs:

```bash
$ bundle exec rake spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/p0deje/watizzle.
This project is intended to be a safe, welcoming space for collaboration,
and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
