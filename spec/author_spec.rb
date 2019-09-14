require 'spec_helper'

describe OrcidClient, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:orcid_token) { ENV['ACCESS_TOKEN'] }
  let(:notification_access_token) { ENV['NOTIFICATION_ACCESS_TOKEN'] }
  let(:put_code) { "740616" }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token, put_code: put_code) }

  context "validate_orcid" do
    it "validate_orcid" do
      orcid = "https://orcid.org/0000-0002-2590-225X"
      response = subject.validate_orcid(orcid)
      expect(response).to eq("0000-0002-2590-225X")
    end

    it "validate_orcid id" do
      orcid = "0000-0002-2590-225X"
      response = subject.validate_orcid(orcid)
      expect(response).to eq("0000-0002-2590-225X")
    end

    it "validate_orcid with spaces" do
      orcid = "0000 0002 1394 3097"
      response = subject.validate_orcid(orcid)
      expect(response).to eq("0000-0002-1394-3097")
    end

    it "validate_orcid wrong id" do
      orcid = "0000-0002-1394-309"
      response = subject.validate_orcid(orcid)
      expect(response).to be_nil
    end
  end
end
