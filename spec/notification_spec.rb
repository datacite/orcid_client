require 'spec_helper'

describe OrcidClient::Notification, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:notification_access_token) { ENV['NOTIFICATION_ACCESS_TOKEN'] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/notification_2.1/samples/" }

  subject { OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: notification_access_token) }

  describe 'schema' do
    it 'validates sample' do
      validation_errors = subject.schema.validate(samples_path + 'notification-permission-2.1.xml').map { |error| error.to_s }
      expect(validation_errors).to be_empty
    end

    it 'exists' do
      expect(subject.schema.errors).to be_empty
    end

    it 'validates data' do
      expect(subject.validation_errors).to be_empty
    end

    it 'validates item type work' do
      subject = OrcidClient::Notification.new(doi: "10.5061/DRYAD.781PV", orcid: "0000-0003-1613-5981", notification_access_token: notification_access_token)
      expect(subject.item_type).to eq("work")
      expect(subject.validation_errors).to be_empty
    end

    it 'validates data with errors' do
      allow(subject).to receive(:metadata) { OpenStruct.new }
      expect(subject.validation_errors).to eq(["-1:0: ERROR: The document has no document element."])
    end
  end

  it 'data' do
    doc = Nokogiri::XML(subject.data)
    expect(doc.at_xpath('//notification:item-name').children.first.text).to eq("Omniauth-Orcid: V.1.1.5")
  end
end
