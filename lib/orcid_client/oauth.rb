require "uri"

module OrcidClient
  module Oauth
    API_VERSION = "2.0_rc3"

    def oauth_client
      OAuth2::Client.new(ENV['ORCID_CLIENT_ID'],
                         ENV['ORCID_CLIENT_SECRET'],
                         site: ENV['ORCID_API_URL'])
    end

    def application_token
      scope = URI.escape("/read-limited /activities/update /person/update")
      @application_token ||= oauth_client.client_credentials.get_token(scope: scope)
    end

    def user_token
      return nil unless access_token.present?

      OAuth2::AccessToken.new(oauth_client, access_token)
    end

    def oauth_client_get(options={})
      options[:endpoint] ||= "orcid-works"
      response = application_token.get "#{ENV['ORCID_API_URL']}/v#{API_VERSION}/#{orcid}/#{options[:endpoint]}" do |request|
        request.headers['Accept'] = 'application/json'
      end

      return { "data" => JSON.parse(response.body) } if response.status == 200

      { "errors" => [{ "title" => "Error fetching ORCID record" }] }
    rescue OAuth2::Error => e
      { "errors" => [{ "title" => e.message }] }
    end

    def oauth_client_post(data, options={})
      return { "errors" => [{ "title" => "User token missing" }] } unless user_token.present?

      options[:endpoint] ||= "orcid-works"
      response = user_token.post("#{ENV['ORCID_API_URL']}/v#{API_VERSION}/#{orcid}/#{options[:endpoint]}") do |request|
        request.headers['Content-Type'] = 'application/orcid+xml'
        request.body = data
      end

      return { "data" => Hash.from_xml(data) } if response.status == 201

      { "errors" => [{ "title" => "Error depositing claim" }] }
    rescue OAuth2::Error => e
      { "errors" => [{ "title" => e.message }] }
    end

    def oauth_client_delete(options={})
      return { "errors" => [{ "title" => "User token missing" }] } unless user_token.present?

      options[:endpoint] ||= "orcid-works/#{doi}"
      response = user_token.delete("#{ENV['ORCID_API_URL']}/v#{API_VERSION}/#{orcid}/#{options[:endpoint]}") do |request|
        request.headers['Accept'] = 'application/json'
      end

      return { "data" => JSON.parse(response.body) } if response.status == 200

      { "errors" => [{ "title" => "Error deleting claim" }] }
    rescue OAuth2::Error => e
      { "errors" => [{ "title" => e.message }] }
    end
  end
end
