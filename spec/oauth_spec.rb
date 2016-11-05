require 'spec_helper'

describe OrcidApi, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidApi::Claim.new(doi: doi, orcid: orcid) }

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
        expect(claims.length).to eq(127)
        claim = claims.first
        expect(claim).to eq("put-code"=>"11649252", "work-title"=>{"title"=>{"value"=>"What Can Article-Level Metrics Do for You?"}, "subtitle"=>{"value"=>"PLoS Biology"}, "translated-title"=>nil}, "journal-title"=>nil, "short-description"=>nil, "work-citation"=>{"work-citation-type"=>"BIBTEX", "citation"=>"@article{Fenner_2013, title={What Can Article-Level Metrics Do for You?}, volume={11}, url={http://dx.doi.org/10.1371/journal.pbio.1001687}, DOI={10.1371/journal.pbio.1001687}, number={10}, journal={PLoS Biology}, publisher={Public Library of Science}, author={Fenner, Martin}, year={2013}, month={Oct}, pages={e1001687}}"}, "work-type"=>"JOURNAL_ARTICLE", "publication-date"=>{"year"=>{"value"=>"2013"}, "month"=>nil, "day"=>nil, "media-type"=>nil}, "work-external-identifiers"=>{"work-external-identifier"=>[{"work-external-identifier-type"=>"DOI", "work-external-identifier-id"=>{"value"=>"10.1371/journal.pbio.1001687"}}, {"work-external-identifier-type"=>"ISSN", "work-external-identifier-id"=>{"value"=>"1545-7885"}}], "scope"=>nil}, "url"=>nil, "work-contributors"=>nil, "work-source"=>nil, "source"=>{"source-orcid"=>{"value"=>nil, "uri"=>"http://orcid.org/0000-0002-3054-1567", "path"=>"0000-0002-3054-1567", "host"=>"orcid.org"}, "source-client-id"=>nil, "source-name"=>{"value"=>"CrossRef Metadata Search"}, "source-date"=>{"value"=>1390657436308}}, "created-date"=>{"value"=>1390657436308}, "last-modified-date"=>{"value"=>1437425776076}, "language-code"=>nil, "country"=>nil, "visibility"=>"PUBLIC")
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

    describe 'oauth_client_delete' do
      it 'should delete' do
        response = subject.oauth_client_delete
        error = response["errors"].first
        expect(error["title"]).to include("Please specify a version number")
      end
    end

    describe 'oauth_client_post invalid token' do
      subject { OrcidApi::Claim.new(doi: doi, orcid: "0000-0003-1419-240x", source_id: "orcid_update") }

      it 'should post' do
        response = subject.oauth_client_post(subject.data)
        expect(response["errors"].first["title"]).to include("Attempt to retrieve a OrcidOauth2TokenDetail with a null or empty token value")
      end
    end
  end
end
