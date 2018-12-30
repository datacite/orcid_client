require 'spec_helper'

describe OrcidClient::Work, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:access_token) { ENV['ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/record_2.1/samples/read_samples/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token) }

  describe 'schema' do
    it 'validates sample' do
      validation_errors = subject.schema.validate(samples_path + 'work-full-2.1.xml').map { |error| error.to_s }
      expect(validation_errors).to be_empty
    end

    it 'exists' do
      expect(subject.schema.errors).to be_empty
    end

    it 'validates data' do
      expect(subject.validation_errors).to be_empty
    end

    it 'validates work type data-set' do
      subject = OrcidClient::Work.new(doi: "10.5061/DRYAD.781PV", orcid: "0000-0003-1613-5981", access_token: access_token)
      expect(subject.type).to eq("data-set")
      expect(subject.validation_errors).to be_empty
    end

    it 'validates work from DataCite test system' do
      subject = OrcidClient::Work.new(doi: "10.4124/ccnjcm4", orcid: "0000-0003-1613-5981", access_token: access_token, sandbox: true)
      expect(subject.type).to eq("data-set")
      expect(subject.validation_errors).to be_empty
    end

    it 'validates ORCID IDs for contributors' do
      subject = OrcidClient::Work.new(doi: "10.2314/COSCV1", orcid: "0000-0001-6528-2027", access_token: access_token)
      expect(subject.validation_errors).to be_empty
    end

    it 'validates data with errors' do
      allow(subject).to receive(:metadata) { OpenStruct.new }
      expect(subject.validation_errors).to eq(["-1:0: ERROR: The document has no document element."])
    end
  end

  describe 'contributors' do
    it 'valid' do
      expect(subject.contributors).to eq([{:credit_name=>"Martin Fenner"},
                                          {:credit_name=>"Gudmundur A. Thorisson"},
                                          {:credit_name=>"Eleanor Kiefel Haggerty"},
                                          {:credit_name=>"Anusha Ranganathan"}])
    end

    it 'literal' do
      subject = OrcidClient::Work.new(doi: "10.1594/PANGAEA.745083", orcid: "0000-0003-3235-5933", access_token: access_token)
      expect(subject.contributors).to eq([{:credit_name=>"EPOCA Arctic Experiment 2009 Team"}])
    end

    it 'with ORCID IDs' do
      subject = OrcidClient::Work.new(doi: "10.2314/COSCV1", orcid: "0000-0001-6528-2027", access_token: access_token)
      expect(subject.contributors).to eq([{:orcid=>"https://orcid.org/0000-0003-0232-7085",
                                           :credit_name=>"Lambert Heller"},
                                          {:orcid=>"https://orcid.org/0000-0002-3075-7640",
                                           :credit_name=>"Ina Blümel"},
                                          {:credit_name=>"Stefan Dietze"},
                                          {:orcid=>"https://orcid.org/0000-0003-1419-2405",
                                           :credit_name=>"Martin Fenner"},
                                          {:orcid=>"https://orcid.org/0000-0002-9314-5633",
                                           :credit_name=>"Sascha Friesike"},
                                          {:orcid=>"https://orcid.org/0000-0003-2499-7741",
                                           :credit_name=>"Christian Hauschke"},
                                          {:credit_name=>"Christian Heise"},
                                          {:orcid=>"https://orcid.org/0000-0003-3271-9653",
                                           :credit_name=>"Robert Jäschke"},
                                          {:orcid=>"https://orcid.org/0000-0002-9813-9208",
                                           :credit_name=>"Ulrich Kleinwechter"},
                                          {:orcid=>"https://orcid.org/0000-0002-8189-8574",
                                           :credit_name=>"Mareike König"},
                                          {:orcid=>"https://orcid.org/0000-0002-7177-9045",
                                           :credit_name=>"Martin Mehlberg"},
                                          {:orcid=>"https://orcid.org/0000-0002-0161-1888",
                                           :credit_name=>"Janna Neumann"},
                                          {:orcid=>"https://orcid.org/0000-0003-3334-2771",
                                           :credit_name=>"Heinz Pampel"},
                                          {:orcid=>"https://orcid.org/0000-0002-5111-2788",
                                           :credit_name=>"Marco Tullney"}])
    end

    it 'multiple titles' do
      subject = OrcidClient::Work.new(doi: "10.6084/M9.FIGSHARE.1537331.V1", orcid: "0000-0003-0811-2536", access_token: access_token)
      expect(subject.contributors).to eq([{:credit_name=>"Iosr Journals"}, {:credit_name=>"Dr. Rohit Arora, MDS"}, {:credit_name=>"Dr. Shalya Raj*.MDS"}])
    end
  end

  it 'publication_date' do
    expect(subject.publication_date).to eq("year"=>"2016", "month"=>"08", "day"=>"11")
  end

  it 'data' do
    xml = File.read(fixture_path + 'work.xml')
    expect(subject.data).to eq(xml)
  end

  describe 'user example' do
    let(:doi) { "10.25596/jalc-2012-017"}
    let(:orcid) {  "0000-0001-6528-2027" }
    
    context "fail" do
      it 'valid' do
        subject = OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token, sandbox: false)

        expect(subject.contributors).to eq([{:credit_name=>"Ronny Harbich"}, {:credit_name=>"Bianca Truthe"}])
      end
    end
  end
end
