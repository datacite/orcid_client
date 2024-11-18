require "date"
require File.expand_path("../lib/orcid_client/version", __FILE__)

Gem::Specification.new do |s|
  s.authors       = "Martin Fenner"
  s.email         = "mfenner@datacite.org"
  s.name          = "orcid_client"
  s.homepage      = "https://github.com/datacite/orcid_client"
  s.summary       = "Ruby client library for the ORCID API"
  s.date          = Date.today
  s.description   = "Ruby client library for the ORCID API."
  s.require_paths = ["lib"]
  s.version       = OrcidClient::VERSION
  s.extra_rdoc_files = ["README.md"]
  s.license       = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Declary dependencies here, rather than in the Gemfile
  s.add_dependency 'activesupport', '>= 7', '< 8'
  s.add_dependency 'bolognese', '~> 2.3'
  s.add_dependency 'builder', '~> 3.2', '>= 3.2.2'
  s.add_dependency 'dotenv', '~> 2.1', '>= 2.1.1'
  s.add_dependency 'maremma', '>= 5.0'
  s.add_dependency 'namae', '~> 1.0.1'
  s.add_dependency 'nokogiri', '>= 1.16.4'
  s.add_development_dependency "bundler", ">= 2.2.10"
  s.add_development_dependency 'rack-test', '~> 0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
end
