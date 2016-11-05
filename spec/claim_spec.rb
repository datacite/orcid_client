require 'spec_helper'

describe OrcidApi::Claim do
  subject { OrcidApi::Claim.new }

  let(:fixture_path) { "spec/fixtures/" }

  describe 'schema', vcr: true do
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
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"Heather A. Piwowar", :role=>nil}, {:orcid=>nil, :credit_name=>"Todd J. Vision", :role=>nil}])
    end

    it 'literal' do
      #subject = FactoryGirl.create(:claim, user: user, orcid: "0000-0003-3235-5933", doi: "10.1594/PANGAEA.745083")
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"EPOCA Arctic experiment 2009 team", :role=>nil}])
    end

    it 'multiple titles' do
      #subject = FactoryGirl.create(:claim, user: user, orcid: "0000-0003-0811-2536", doi: "10.6084/M9.FIGSHARE.1537331.V1")
      expect(subject.contributors).to eq([{:orcid=>nil, :credit_name=>"Iosr journals", :role=>nil}, {:orcid=>nil, :credit_name=>"Dr. Rohit Arora, MDS", :role=>nil}, {:orcid=>nil, :credit_name=>"Shalya Raj*.MDS", :role=>nil}])
    end
  end

  it 'publication_date' do
    expect(subject.publication_date).to eq("year" => 2013)
  end

  it 'citation' do
    expect(subject.citation).to eq("@data{http://doi.org/10.5061/DRYAD.781PV, author = {Piwowar, Heather A. and Vision, Todd J.}, title = {Data from: Data reuse and the open data citation advantage}, publisher = {Dryad Digital Repository}, doi = {10.5061/DRYAD.781PV}, url = {http://doi.org/10.5061/DRYAD.781PV}, year = {2013}}")
  end

  it 'data' do
    xml = File.read(fixture_path + 'claim.xml')
    expect(subject.data).to eq(xml)
  end
end
