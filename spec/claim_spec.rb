require 'spec_helper'

describe OrcidApi::Claim, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidApi::Claim.new(doi: doi, orcid: orcid) }

  describe 'schema' do
    it 'exists' do
      expect(subject.schema.errors).to be_empty
    end

    it 'validates data' do
      expect(subject.validation_errors).to be_empty
    end

    it 'validates data with errors' do
      allow(subject).to receive(:metadata) { {} }
      expect(subject.validation_errors).to eq(["The document has no document element."])
    end
  end

  describe 'contributors' do
    it 'valid' do
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"Martin Fenner", :role=>nil},
                                          {:orcid=>nil, :credit_name=>"Gudmundur A. Thorisson", :role=>nil},
                                          {:orcid=>nil, :credit_name=>"Eleanor Kiefel Haggerty", :role=>nil},
                                          {:orcid=>nil, :credit_name=>"Anusha Ranganathan", :role=>nil}])
    end

    it 'literal' do
      subject = OrcidApi::Claim.new(doi: "10.1594/PANGAEA.745083", orcid: "0000-0003-3235-5933")
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"EPOCA Arctic experiment 2009 team", :role=>nil}])
    end

    it 'multiple titles' do
      subject = OrcidApi::Claim.new(doi: "10.6084/M9.FIGSHARE.1537331.V1", orcid: "0000-0003-0811-2536")
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"Iosr journals", :role=>nil}, {:orcid=>nil, :credit_name=>"Dr. Rohit Arora, MDS", :role=>nil}, {:orcid=>nil, :credit_name=>"Shalya Raj*.MDS", :role=>nil}])
    end
  end

  it 'publication_date' do
    expect(subject.publication_date).to eq("year" => 2016)
  end

  it 'citation' do
    expect(subject.citation).to eq("@data{https://doi.org/10.5281/zenodo.59983, author = {Fenner, Martin and Thorisson, Gudmundur A. and Haggerty, Eleanor Kiefel and Ranganathan, Anusha}, title = {omniauth-orcid: v.1.1.5}, publisher = {Zenodo}, doi = {10.5281/zenodo.59983}, url = {https://doi.org/10.5281/zenodo.59983}, year = {2016}}")
  end

  it 'data' do
    xml = File.read(fixture_path + 'orcid-work.xml')
    expect(subject.data).to eq(xml)
  end
end
