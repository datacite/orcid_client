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
  s.required_ruby_version = ['>= 3.2', '< 4.1']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Declary dependencies here, rather than in the Gemfile
  s.add_dependency 'activesupport', '~> 8.1', '>= 8.1.2'
  s.add_dependency 'bolognese', '~> 2.6.0'
  s.add_dependency 'builder', '~> 3.3'
  s.add_dependency 'dotenv', '~> 3.2'
  s.add_dependency 'maremma', '~> 6.0'
  s.add_dependency 'namae', '~> 1.2'
  s.add_dependency 'nokogiri', '>= 1.19', '>= 1.19.1'
  s.add_development_dependency 'bundler', '>= 2.2.10'
  s.add_development_dependency 'rack-test', '~> 2.2'
  s.add_development_dependency 'rake', '~> 13.3', '>= 13.3.1'
  s.add_development_dependency 'rspec', '~> 3.13', '>= 3.13.2'
  s.add_development_dependency 'simplecov', '~> 0.22.0'
  s.add_development_dependency 'vcr', '~> 6.4'
  s.add_development_dependency 'webmock', '~> 3.26', '>= 3.26.1'
end
