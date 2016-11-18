require "uri"

module OrcidClient
  module Api
    API_VERSION = "2.0_rc3"

    def get_works(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/works"
      Maremma.get(url, accept: 'json', bearer: access_token)
    end

    def create_work(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work"
      Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: access_token)
    end

    def update_work(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?
      return { "errors" => [{ "title" => "Put code missing" }] } unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work/#{put_code}"
      Maremma.put(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: access_token)
    end

    def delete_work(options={})
      return { "errors" => [{ "title" => "Access token missing" }] } unless access_token.present?
      return { "errors" => [{ "title" => "Put code missing" }] } unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work/#{put_code}"
      Maremma.delete(url, content_type: 'application/vnd.orcid+xml', bearer: access_token)
    end

    def get_notification_access_token(client_id:, client_secret:, **options)
      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      params = { 'client_id' => client_id,
                 'client_secret' => client_secret,
                 'scope' => '/premium-notification',
                 'grant_type' => 'client_credentials' }

      url = "#{orcid_api_url}/oauth/token"
      data = URI.encode_www_form(params)
      Maremma.post(url, content_type: 'application/x-www-form-urlencoded', data: data, accept: 'application/json')
    end

    def create_notification(options={})
      return { "errors" => [{ "title" => "Notification access token missing" }] } unless notification_access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/notification-permission"
      Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: notification_access_token)
    end
  end
end
