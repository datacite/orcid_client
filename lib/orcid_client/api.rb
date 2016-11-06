require "uri"

module OrcidClient
  module Api
    API_VERSION = "2.0_rc3"

    def get_works(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      url = "#{ENV['ORCID_API_URL']}/v#{API_VERSION}/#{orcid}/works"
      response = Maremma.get(url, accept: 'json', bearer: access_token)
    end

    def create_work(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      url = "#{ENV['ORCID_API_URL']}/v#{API_VERSION}/#{orcid}/works"
      response = Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: access_token)
    end
  end
end
