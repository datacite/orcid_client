require "date"
require File.expand_path("../lib/orcid_api/version", __FILE__)

Gem::Specification.new do |s|
  s.authors       = "Martin Fenner"
  s.email         = "mfenner@datacite.org"
  s.name          = "orcid_api"
  s.homepage      = "https://github.com/datacite/orcid_api"
  s.summary       = "Client library for the ORCID API"
  s.date          = Date.today
  s.description   = "Client library for the ORCID API."
  s.require_paths = ["lib"]
  s.version       = OrcidApi::VERSION
  s.extra_rdoc_files = ["README.md"]
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Declary dependencies here, rather than in the Gemfile
  s.add_dependency 'maremma', '~> 2.3.1'
  s.add_dependency 'nokogiri', '~> 1.6.8'
  s.add_dependency 'builder', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'bibtex-ruby', '~> 4.2'
  s.add_dependency 'namae', '~> 0.10.1'
  s.add_dependency 'activesupport', '~> 4.2', '>= 4.2.5'
  s.add_dependency 'oauth2', '~> 1.2'
  s.add_dependency 'dotenv', '~> 2.1', '>= 2.1.1'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rack-test', '~> 0'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock', '~> 1.22', '>= 1.22.3'
  s.add_development_dependency 'codeclimate-test-reporter', "~> 1.0.0"
  s.add_development_dependency 'simplecov'
end
