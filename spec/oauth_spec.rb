require 'spec_helper'

describe OrcidClient, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:access_token) { ENV['ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token) }

  describe 'push to ORCID' do

    describe 'token' do
      it 'should return the user_token' do
        expect(subject.user_token.client.site).to eq("https://api.sandbox.orcid.org")
      end

      it 'should return the application_token' do
        expect(subject.application_token.client.site).to eq("https://api.sandbox.orcid.org")
      end
    end

    describe 'oauth_client_get' do
      it 'should get' do
        response = subject.oauth_client_get
        claims = response["data"].fetch("orcid-profile", {})
                                 .fetch("orcid-activities", {})
                                 .fetch("orcid-works", {})
                                 .fetch("orcid-work", [])
        expect(claims.length).to eq(27)
        claim = claims.first
        expect(claim["work-title"]).to eq("title"=>{"value"=>"DataCite-ORCID: 1.0"}, "subtitle"=>nil, "translated-title"=>nil)
      end
    end

    describe 'oauth_client_post' do
      it 'should post' do
        response = subject.oauth_client_post(subject.data)
        claim = response.fetch("data", {})
                        .fetch("orcid_message", {})
                        .fetch("orcid_profile", {})
                        .fetch("orcid_activities", {})
                        .fetch("orcid_works", {})
                        .fetch("orcid_work", {})
        expect(claim["work_title"]).to eq("title"=>"omniauth-orcid: v.1.0")
      end
    end

    # describe 'oauth_client_delete' do
    #   it 'should delete' do
    #     response = subject.oauth_client_delete
    #     error = response["errors"].first
    #     expect(error["title"]).to include("Please specify a version number")
    #   end
    # end

    describe 'oauth_client_post invalid token' do
      subject { OrcidClient::Work.new(doi: doi, orcid: "0000-0003-1419-240x", access_token: access_token) }

      it 'should post' do
        response = subject.oauth_client_post(subject.data)
        expect(response["errors"].first["title"]).to include("Attempt to retrieve a OrcidOauth2TokenDetail with a null or empty token value")
      end
    end
  end
end
