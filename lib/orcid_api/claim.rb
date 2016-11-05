require 'nokogiri'
require 'bibtex'
require 'oauth2'
require_relative 'metadata'
require_relative 'oauth'

module OrcidApi
  class Claim
    include OrcidApi::Metadata
    include OrcidApi::Oauth

    attr_reader :doi, :orcid, :schema, :authentication_token, :validation_errors

    # # include view helpers
    # include ActionView::Helpers::TextHelper

    # # include helper module for DOI resolution
    # include Resolvable

    # # include helper module for date and time calculations
    # include Dateable

    # # include helper module for author name parsing
    # include Authorable

    # # include helper module for work type
    # include Typeable

    # # include helper module for ORCID claims
    # include Orcidable

    # def create_uuid
    #   write_attribute(:uuid, SecureRandom.uuid) if uuid.blank?
    # end

    def initialize(doi:, orcid:, **options)
      @doi = doi
      @orcid = orcid
    end

    ORCID_SCHEMA = 'https://raw.githubusercontent.com/ORCID/ORCID-Source/master/orcid-model/src/main/resources/orcid-message-1.2.xsd'

    def metadata
      @metadata ||= get_metadata(doi, 'datacite')
    end

    def contributors
      Array(metadata.fetch('author', nil)).map do |contributor|
        { orcid: contributor.fetch('ORCID', nil),
          credit_name: get_credit_name(contributor),
          role: nil }
      end
    end

    def author_string
      Array(metadata.fetch('author', nil)).map do |contributor|
        get_full_name(contributor)
      end.join(" and ")
    end

    def title
      metadata.fetch('title', nil)
    end

    def container_title
      metadata.fetch('container-title', nil)
    end

    def publisher_id
      metadata.fetch('publisher_id', nil)
    end

    def publication_date
      get_year_month_day(metadata.fetch('published', nil))
    end

    def description
      Array(metadata.fetch('description', nil)).first
    end

    def type
      orcid_work_type(metadata.fetch('type', nil), metadata.fetch('subtype', nil))
    end

    def citation
      return nil unless contributors && title && container_title && publication_date

      url = "https://doi.org/#{doi}"

      # generate citation in bibtex format. Use the url as bibtex key.
      # TODO set correct bibtex type

      BibTeX::Entry.new({
        bibtex_type: :data,
        bibtex_key: url,
        author: author_string,
        title: title,
        publisher: container_title,
        doi: doi,
        url: url,
        year: publication_date['year']
      }).to_s.gsub("\n",'').gsub(/\s+/, ' ')
    end

    def data
      # check for DataCite required metadata
      return nil unless doi && contributors && title && container_title && publication_date

      Nokogiri::XML::Builder.new do |xml|
        xml.send(:'orcid-message', root_attributes) do
          xml.send(:'message-version', ORCID_VERSION)
          xml.send(:'orcid-profile') do
            xml.send(:'orcid-activities') do
              xml.send(:'orcid-works') do
                xml.send(:'orcid-work') do
                  insert_work(xml)
                end
              end
            end
          end
        end
      end.to_xml
    end

    def insert_work(xml)
      insert_titles(xml)
      insert_description(xml)
      insert_citation(xml)
      insert_type(xml)
      insert_pub_date(xml)
      insert_ids(xml)
      insert_contributors(xml)
    end

    def insert_titles(xml)
      if title
        xml.send(:'work-title') do
          xml.title(title)
        end
      end

      xml.send(:'journal-title', container_title) if container_title
    end

    def insert_description(xml)
      return nil unless description.present?

      xml.send(:'short-description', truncate(description, length: 2500, separator: ' '))
    end

    def insert_citation(xml)
      return nil unless citation.present?

      xml.send(:'work-citation') do
        xml.send(:'work-citation-type', 'bibtex')
        xml.citation(citation)
      end
    end

    def insert_type(xml)
      xml.send(:'work-type', type)
    end

    def insert_pub_date(xml)
      if publication_date['year']
        xml.send(:'publication-date') do
          xml.year(publication_date.fetch('year'))
          xml.month(publication_date.fetch('month', nil)) if publication_date['month']
          xml.day(publication_date.fetch('day', nil)) if publication_date['month'] && publication_date['day']
        end
      end
    end

    def insert_ids(xml)
      xml.send(:'work-external-identifiers') do
        insert_id(xml, 'doi', doi)
      end
    end

    def insert_id(xml, id_type, value)
      xml.send(:'work-external-identifier') do
        xml.send(:'work-external-identifier-type', id_type)
        xml.send(:'work-external-identifier-id', value)
      end
    end

    def insert_contributors(xml)
      return nil unless contributors.present?

      xml.send(:'work-contributors') do
        contributors.each do |contributor|
          xml.contributor do
            insert_contributor(xml, contributor)
          end
        end
      end
    end

    def insert_contributor(xml, contributor)
      #xml.send(:'contributor-orcid', contributor[:orcid]) if contributor[:orcid]
      xml.send(:'credit-name', contributor[:credit_name])
      if contributor[:role]
        xml.send(:'contributor-attributes') do
          xml.send(:'contributor-role', contributor[:role])
        end
      end
    end

    def without_control(s)
      r = ''
      s.each_codepoint do |c|
        if c >= 32
          r << c
        end
      end
      r
    end

    def root_attributes
      { :'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        :'xsi:schemaLocation' => 'http://www.orcid.org/ns/orcid https://raw.github.com/ORCID/ORCID-Source/master/orcid-model/src/main/resources/orcid-message-1.2.xsd',
        :'xmlns' => 'http://www.orcid.org/ns/orcid' }
    end

    def schema
      Nokogiri::XML::Schema(open(ORCID_SCHEMA))
    end

    def validation_errors
      @validation_errors ||= schema.validate(Nokogiri::XML(data)).map { |error| error.to_s }
    end
  end
end
