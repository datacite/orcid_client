require "uri"

module OrcidClient
  module Api
    API_VERSION = "3.0"

    def get_works(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/works"
      Maremma.get(url, accept: 'json', bearer: orcid_token)
    end

    def create_work(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work"
      response = Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: orcid_token)
      put_code = response.headers.present? ? response.headers.fetch("Location", "").split("/").last : nil
      response.body["put_code"] = put_code.present? ? put_code.to_i : nil
      response
    end

    def update_work(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?
      return OpenStruct.new(body: { "errors" => [{ "title" => "Put code missing" }] }) unless put_code.present?

      visibility = nil
      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work/#{put_code}"
      response = Maremma.put(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: orcid_token)
      put_code = response.headers.present? ? response.headers.fetch("Location", "").split("/").last : nil
      response.body["put_code"] = put_code.present? ? put_code.to_i : nil
      response
    end

    def delete_work(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?
      return OpenStruct.new(body: { "errors" => [{ "title" => "Put code missing" }] }) unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/work/#{put_code}"
      Maremma.delete(url, content_type: 'application/vnd.orcid+xml', bearer: orcid_token)
    end

    def create_external_identifier(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/external-identifiers"
      response = Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: orcid_token)
      put_code = response.headers.present? ? response.headers.fetch("Location", "").split("/").last : nil
      response.body["put_code"] = put_code.present? ? put_code.to_i : nil
      response
    end

    def delete_external_identifier(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "ORCID access token missing" }] }) unless orcid_token.present?
      return OpenStruct.new(body: { "errors" => [{ "title" => "Put code missing" }] }) unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/external-identifiers/#{put_code}"
      Maremma.delete(url, content_type: 'application/vnd.orcid+xml', bearer: orcid_token)
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
      return OpenStruct.new(body: { "errors" => [{ "title" => "Notification access token missing" }] }) unless notification_access_token.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/notification-permission"
      response = Maremma.post(url, content_type: 'application/vnd.orcid+xml', data: data, bearer: notification_access_token)
      put_code = response.headers.present? ? response.headers.fetch("Location", "").split("/").last : nil
      response.body["put_code"] = put_code.present? ? put_code.to_i : nil
      response
    end

    def delete_notification(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "Notification access token missing" }] }) unless notification_access_token.present?
      return OpenStruct.new(body: { "errors" => [{ "title" => "Put code missing" }] }) unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/notification-permission/#{put_code}"
      Maremma.delete(url, content_type: 'application/vnd.orcid+xml', bearer: notification_access_token)
    end

    def get_notification(options={})
      return OpenStruct.new(body: { "errors" => [{ "title" => "Notification access token missing" }] }) unless notification_access_token.present?
      return OpenStruct.new(body: { "errors" => [{ "title" => "Put code missing" }] }) unless put_code.present?

      orcid_api_url = options[:sandbox] ? 'https://api.sandbox.orcid.org' : 'https://api.orcid.org'

      url = "#{orcid_api_url}/v#{API_VERSION}/#{orcid}/notification-permission/#{put_code}"
      Maremma.get(url, content_type: 'application/vnd.orcid+xml', bearer: notification_access_token)
    end
  end
end
