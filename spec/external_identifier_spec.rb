require 'spec_helper'

describe OrcidClient::ExternalIdentifier, vcr: true do
  let(:type) { "GitHub" }
  let(:value) { "mfenner" }
  let(:url) { "https://github.com/#{value}" }
  let(:orcid) { "0000-0001-6528-2027" }
  let(:orcid_token) { ENV['ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/record_2.1/samples/read_samples/" }

  subject { OrcidClient::ExternalIdentifier.new(type: type, value: value, url: url, orcid: orcid, orcid_token: orcid_token) }

  describe 'schema' do
    it 'validates sample' do
      validation_errors = subject.schema.validate(samples_path + 'external-identifier-2.1.xml').map { |error| error.to_s }
      expect(validation_errors).to be_empty
    end

    it 'exists' do
      expect(subject.schema.errors).to be_empty
    end

    it 'validates data' do
      expect(subject.validation_errors).to be_empty
    end
  end

  it 'data' do
    xml = File.read(fixture_path + 'external_identifier.xml')
    expect(subject.data).to eq(xml)
  end
end
