require 'spec_helper'

describe OrcidClient::Work, vcr: true do
  let(:doi) { "10.5438/h5xp-x178"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:orcid_token) { ENV['ORCID_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/record_3.0/samples/read_samples/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token) }

  describe 'schema' do
    it 'validates sample' do
      validation_errors = subject.schema.validate(samples_path + 'work-full-3.0.xml').map { |error| error.to_s }
      expect(validation_errors).to be_empty
    end

    it 'exists' do
      expect(subject.schema.errors).to be_empty
    end

    it 'validates data' do
      expect(subject.validation_errors).to be_empty
    end

    it 'validates work type data-set' do
      subject = OrcidClient::Work.new(doi: "10.14454/sgfx-x272", orcid: "0000-0003-1981-1623", orcid_token: orcid_token)
      expect(subject.type).to eq("data-set")
      expect(subject.validation_errors).to be_empty
    end

    it 'validates ORCID IDs for contributors' do
      subject = OrcidClient::Work.new(doi: "10.5438/h5xp-x178", orcid: "0000-0001-6528-2027", orcid_token: orcid_token)
      expect(subject.validation_errors).to be_empty
    end

    it 'validates data with errors' do
      allow(subject).to receive(:metadata) { OpenStruct.new }
      expect(subject.validation_errors).to eq(["-1:0: ERROR: The document has no document element."])
    end
  end

  describe 'contributors' do
    it 'valid' do
      expect(subject.contributors).to eq([{:credit_name=>"Martin Fenner",
        :orcid=>"https://orcid.org/0000-0003-1419-2405"}])
    end

    # it 'literal' do
    #   subject = OrcidClient::Work.new(doi: "10.1594/PANGAEA.745083", orcid: "0000-0003-3235-5933", orcid_token: orcid_token)
    #   expect(subject.contributors).to eq([{:credit_name=>"EPOCA Arctic Experiment 2009 Team"}])
    # end

    it 'with ORCID IDs' do
      subject = OrcidClient::Work.new(doi: "10.5438/h5xp-x178", orcid: "0000-0001-6528-2027", orcid_token: orcid_token)
      expect(subject.contributors).to eq([{:credit_name=>"Martin Fenner",
        :orcid=>"https://orcid.org/0000-0003-1419-2405"}])
    end
  end

  it 'publication_date' do
    expect(subject.publication_date).to eq("year"=>"2016", "month"=>"12", "day"=>"15")
  end

  it 'data' do
    xml = File.read(fixture_path + 'work.xml')
    expect(subject.data).to eq(xml)
  end

  # describe 'user example' do
  #   let(:doi) { "10.25596/jalc-2012-017"}
  #   let(:orcid) {  "0000-0001-6528-2027" }
    
  #   context "fail" do
  #     it 'valid' do
  #       subject = OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token, sandbox: false)

  #       expect(subject.contributors).to eq([{:credit_name=>"Ronny Harbich"}, {:credit_name=>"Bianca Truthe"}])
  #     end
  #   end
  # end
end
