module OrcidClient
  module Author
    include Bolognese::AuthorUtils
    include Bolognese::Utils

    def get_credit_name(author)
      [author['given'], author['family']].compact.join(' ').presence || author['literal']
    end

    def get_full_name(author)
      [author['family'], author['given']].compact.join(', ')
    end
  end
end
