require 'active_support/all'
require 'nokogiri'

require_relative 'api'
require_relative 'base'

module OrcidClient
  class ExternalIdentifier
    include OrcidClient::Base
    include OrcidClient::Api

    attr_reader :type, :value, :url, :orcid, :schema, :access_token, :put_code, :validation_errors

    def initialize(type:, value:, url:, orcid:, access_token:, **options)
      @type = type
      @value = value
      @url = url
      @orcid = orcid
      @access_token = access_token
      @put_code = options.fetch(:put_code, nil)
    end

    SCHEMA = File.expand_path("../../../resources/record_#{API_VERSION}/person-external-identifier-#{API_VERSION}.xsd", __FILE__)

    def data
      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:'external-identifier:external-identifier', root_attributes) do
          insert_external_identifier(xml)
        end
      end.to_xml
    end

    def insert_external_identifier(xml)
      insert_id(xml)
    end

    def insert_id(xml)
      xml.send(:'common:external-id-type', type)
      xml.send(:'common:external-id-value', value)
      xml.send(:'common:external-id-url', url)
      xml.send(:'common:external-id-relationship', "self")
    end

    def root_attributes
      { :'put-code' => put_code,
        :'visibility' => 'public',
        :'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        :'xsi:schemaLocation' => 'http://www.orcid.org/ns/external-identifier ../person-external-identifier-2.1.xsd',
        :'xmlns:common' => 'http://www.orcid.org/ns/common',
        :'xmlns:external-identifier' => 'http://www.orcid.org/ns/external-identifier' }.compact
    end

    def schema
      Nokogiri::XML::Schema(open(SCHEMA))
    end

    def validation_errors
      @validation_errors ||= schema.validate(Nokogiri::XML(data)).map { |error| error.to_s }
    end
  end
end
