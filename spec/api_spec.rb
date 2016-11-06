require 'spec_helper'

describe OrcidClient, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:access_token) { ENV['ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token) }

  describe 'get' do
    it 'should get works' do
      response = subject.get_works
      works = response.fetch("data", {}).fetch("group", {})
      expect(works.length).to eq(27)
      work = works.first
      expect(work["external-ids"]).to eq("external-id"=>[{"external-id-type"=>"doi", "external-id-value"=>"10.5167/UZH-19531", "external-id-url"=>nil, "external-id-relationship"=>"SELF"}])
    end
  end

  describe 'post' do
    it 'should create work' do
      response = subject.create_work
      pp response
    end
  end

    # describe 'oauth_client_delete' do
    #   it 'should delete' do
    #     response = subject.oauth_client_delete
    #     error = response["errors"].first
    #     expect(error["title"]).to include("Please specify a version number")
    #   end
    # end

  #   describe 'oauth_client_post invalid token' do
  #     subject { OrcidClient::Work.new(doi: doi, orcid: "0000-0003-1419-240x", access_token: access_token) }

  #     it 'should post' do
  #       response = subject.oauth_client_post(subject.data)
  #       expect(response["errors"].first["title"]).to include("Attempt to retrieve a OrcidOauth2TokenDetail with a null or empty token value")
  #     end
  #   end
  # end
end
