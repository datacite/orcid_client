# Ruby client for ORCID API

[![Gem Version](https://badge.fury.io/rb/orcid_client.svg)](https://badge.fury.io/rb/orcid_client)
![Build Ruby Gem](https://github.com/datacite/orcid_client/workflows/Build%20Ruby%20Gem/badge.svg)
[![Test Coverage](https://codeclimate.com/github/datacite/orcid_client/badges/coverage.svg)](https://codeclimate.com/github/datacite/orcid_client/coverage)
[![Code Climate](https://codeclimate.com/github/datacite/orcid_client/badges/gpa.svg)](https://codeclimate.com/github/datacite/orcid_client)

Ruby gem for integrating Ruby applications with the ORCID API.

## Features

The following functionality is supported:

- get all works from an ORCID record, including those set to limited access
- create work in an ORCID record
- create notification for an ORCID record (needs special permissions)

## Requirements

- [ORCID membership](https://orcid.org/about/membership), needed to create, update or delete content via the ORCID API
- valid access tokens for ORCID user accounts, collected and safely stored in your application using for example the [omniauth-orcid](https://github.com/datacite/omniauth-orcid) gem.

## Installation

The usual way with Bundler: add the following to your `Gemfile` to install the current version of the gem:

```ruby
gem 'orcid_client'
```

Then run `bundle install` to install into your environment.

You can also install the gem system-wide in the usual way:

```bash
gem install orcid_client
```

## Use

TBD.

## License

[MIT](license.md)
