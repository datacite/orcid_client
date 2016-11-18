require 'active_support/all'
require 'nokogiri'

require_relative 'api'
require_relative 'author'
require_relative 'base'
require_relative 'date'
require_relative 'metadata'

module OrcidClient
  class Notification
    include OrcidClient::Base
    include OrcidClient::Metadata
    include OrcidClient::Author
    include OrcidClient::Date
    include OrcidClient::Api

    attr_reader :doi, :orcid, :schema, :notification_access_token, :put_code, :subject, :intro, :notification_host, :validation_errors

    def initialize(doi:, orcid:, notification_access_token:, **options)
      @doi = doi
      @orcid = orcid
      @notification_access_token = notification_access_token
      @put_code = options.fetch(:put_code, nil)
      @subject = options.fetch(:subject, nil)
      @intro = options.fetch(:intro, nil)
      @notification_host = options[:sandbox] ? 'sandbox.orcid.org' : 'orcid.org'
    end

    SCHEMA = File.expand_path("../../../resources/notification_#{API_VERSION}/notification-permission-#{API_VERSION}.xsd", __FILE__)

    def metadata
      @metadata ||= get_metadata(doi, 'datacite')
    end

    def item_name
      metadata.fetch('title', nil)
    end

    def item_type
      "work"
    end

    def has_required_elements?
      doi && item_name
    end

    def data
      return nil unless has_required_elements?

      Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.send(:'notification:notification', root_attributes) do
          insert_notification(xml)
        end
      end.to_xml
    end

    def insert_notification(xml)
      insert_notification_type(xml)
      insert_authorization_url(xml)
      insert_notification_subject(xml)
      insert_notification_intro(xml)
      insert_items(xml)
    end

    def insert_notification_type(xml)
      xml.send(:'notification:notification-type', "permission")
    end

    def insert_authorization_url(xml)
      xml.send(:'notification:authorization-url') do
        xml.send(:'notification:path', work_notification_path)
        xml.send(:'notification:host', notification_host)
      end
    end

    def work_notification_path
      "/oauth/authorize?client_id=#{ENV['ORCID_CLIENT_ID']}&response_type=code&scope=/read-limited%20/activities/update%20/person/update&redirect_uri=#{ENV['REDIRECT_URI']}"
    end

    def insert_notification_subject(xml)
      xml.send(:'notification:notification-subject', subject)
    end

    def insert_notification_intro(xml)
      xml.send(:'notification:notification-intro', intro)
    end

    def insert_items(xml)
      return nil unless has_required_elements?

      xml.send(:'notification:items') do
        xml.send(:'notification:item') do
          xml.send(:'notification:item-type', item_type)
          xml.send(:'notification:item-name', item_name)

          insert_id(xml, "doi", doi, "self")
        end
      end
    end

    def insert_id(xml, id_type, value, relationship)
      xml.send(:'common:external-id') do
        xml.send(:'common:external-id-type', id_type)
        xml.send(:'common:external-id-value', value)
        xml.send(:'common:external-id-relationship', relationship)
      end
    end

    def root_attributes
      { :'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        :'xsi:schemaLocation' => 'http://www.orcid.org/ns/notification ../notification-permission-2.0_rc3.xsd',
        :'xmlns:common' => 'http://www.orcid.org/ns/common',
        :'xmlns:notification' => 'http://www.orcid.org/ns/notification' }
    end

    def schema
      Nokogiri::XML::Schema(open(SCHEMA))
    end

    def validation_errors
      @validation_errors ||= schema.validate(Nokogiri::XML(data)).map { |error| error.to_s }
    end
  end
end
