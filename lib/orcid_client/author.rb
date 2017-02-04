require 'namae'

module OrcidClient
  module Author
    def validate_orcid(orcid)
      orcid = Array(/\A(?:http:\/\/orcid\.org\/)?(\d{4}[[:space:]-]\d{4}[[:space:]-]\d{4}[[:space:]-]\d{3}[0-9X]+)\z/.match(orcid)).last
      orcid.gsub(/[[:space:]]/, "-") if orcid.present?
    end

    # parse author string into CSL format
    def get_one_author(author)
      return "" if author.blank?

      names = Namae.parse(author)
      if names.present?
        name = names.first

        { "family" => name.family,
          "given" => name.given }.compact
      else
        { "literal" => author }
      end
    end

    # parse array of author strings into CSL format
    def get_authors(authors)
      Array(authors).map { |author| get_one_author(author) }
    end

    # parse array of author hashes into CSL format
    def get_hashed_authors(authors)
      Array(authors).map { |author| get_one_hashed_author(author) }
    end

    def get_one_hashed_author(author)
      raw_name = author.fetch("creatorName", nil)

      author_hsh = get_one_author(raw_name)
      author_hsh["ORCID"] = get_name_identifier(author)
      author_hsh.compact
    end

    def get_name_identifier(author)
      name_identifier = author.fetch("nameIdentifier", nil)
      name_identifier_scheme = author.fetch("nameIdentifierScheme", "orcid").downcase
      if name_identifier_scheme == "orcid" && name_identifier = validate_orcid(name_identifier)
        "http://orcid.org/#{name_identifier}"
      else
        nil
      end
    end

    def get_credit_name(author)
      [author['given'], author['family']].compact.join(' ').presence || author['literal']
    end

    def get_full_name(author)
      [author['family'], author['given']].compact.join(', ')
    end
  end
end
