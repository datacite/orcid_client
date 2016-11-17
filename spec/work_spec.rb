require 'spec_helper'

describe OrcidClient::Work, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:access_token) { ENV['ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/record_2.0_rc3/samples/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token) }

  describe 'schema' do
    it 'validates sample' do
      validation_errors = subject.schema.validate(samples_path + 'work-full-2.0_rc3.xml').map { |error| error.to_s }
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

    it 'validates ORCID IDs for contributors' do
      subject = OrcidClient::Work.new(doi: "10.2314/COSCV1", orcid: "0000-0001-6528-2027", access_token: access_token)
      expect(subject.validation_errors).to be_empty
    end

    it 'validates data with errors' do
      allow(subject).to receive(:metadata) { {} }
      expect(subject.validation_errors).to eq(["The document has no document element."])
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
      expect(subject.contributors).to eq([{:credit_name=>"EPOCA Arctic experiment 2009 team"}])
    end

    it 'with ORCID IDs' do
      subject = OrcidClient::Work.new(doi: "10.2314/COSCV1", orcid: "0000-0001-6528-2027", access_token: access_token)
      expect(subject.contributors).to eq([{:orcid=>"http://orcid.org/0000-0003-0232-7085",
                                           :credit_name=>"Lambert Heller"},
                                          {:orcid=>"http://orcid.org/0000-0002-3075-7640",
                                           :credit_name=>"Ina Blümel"},
                                          {:credit_name=>"Stefan Dietze"},
                                          {:orcid=>"http://orcid.org/0000-0003-1419-2405",
                                           :credit_name=>"Martin Fenner"},
                                          {:orcid=>"http://orcid.org/0000-0002-9314-5633",
                                           :credit_name=>"Sascha Friesike"},
                                          {:orcid=>"http://orcid.org/0000-0003-2499-7741",
                                           :credit_name=>"Christian Hauschke"},
                                          {:credit_name=>"Christian Heise"},
                                          {:orcid=>"http://orcid.org/0000-0003-3271-9653",
                                           :credit_name=>"Robert Jäschke"},
                                          {:orcid=>"http://orcid.org/0000-0002-9813-9208",
                                           :credit_name=>"Ulrich Kleinwechter"},
                                          {:orcid=>"http://orcid.org/0000-0002-8189-8574",
                                           :credit_name=>"Mareike König"},
                                          {:orcid=>"http://orcid.org/0000-0002-7177-9045",
                                           :credit_name=>"Martin Mehlberg"},
                                          {:orcid=>"http://orcid.org/0000-0002-0161-1888",
                                           :credit_name=>"Janna Neumann"},
                                          {:orcid=>"http://orcid.org/0000-0003-3334-2771",
                                           :credit_name=>"Heinz Pampel"},
                                          {:orcid=>"http://orcid.org/0000-0002-5111-2788",
                                           :credit_name=>"Marco Tullney"}])
    end

    it 'multiple titles' do
      subject = OrcidClient::Work.new(doi: "10.6084/M9.FIGSHARE.1537331.V1", orcid: "0000-0003-0811-2536", access_token: access_token)
      expect(subject.contributors).to eq([{:credit_name=>"Iosr journals"}, {:credit_name=>"Dr. Rohit Arora, MDS"}, {:credit_name=>"Shalya Raj*.MDS"}])
    end
  end

  it 'publication_date' do
    expect(subject.publication_date).to eq("year" => 2016)
  end

  it 'data' do
    xml = File.read(fixture_path + 'work.xml')
    expect(subject.data).to eq(xml)
  end
end
