require "uri"

module OrcidClient
  module Api
    API_VERSION = "2.0_rc3"

    def get_works(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/works"
      response = Maremma.get(url, accept: 'json', bearer: access_token)
    end

    def create_work(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/works"
      response = Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: access_token)
    end
  end
end
