require 'spec_helper'

describe OrcidClient, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:orcid_token) { ENV["ACCESS_TOKEN"] }
  let(:notification_access_token) { ENV["NOTIFICATION_ACCESS_TOKEN"] }
  let(:put_code) { "921977" }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token, put_code: put_code) }

  describe "works", :order => :defined do
    describe 'post' do
      subject { OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token) }

      it 'should create work' do
        response = subject.create_work(sandbox: true)
        expect(response.body["put_code"]).not_to be_blank
        expect(response.status).to eq(201)
      end

      it 'orcid_token missing' do
        subject = OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: nil)
        response = subject.create_work(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end

    describe 'get' do
      it 'should get works' do
        response = subject.get_works(sandbox: true)
        works = response.body.fetch("data", {}).fetch("group", {})
        expect(works.length).to eq(23)
        work = works.first
        expect(work["external-ids"]).to eq("external-id"=>[{"external-id-relationship"=>"SELF", "external-id-type"=>"doi", "external-id-url"=>nil, "external-id-value"=>"10.5256/f1000research.67475.r16884"}])
      end

      it 'orcid_token missing' do
        subject = OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: nil)
        response = subject.get_works(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end

    describe 'put' do
      # it 'should update work' do
      #   response = subject.update_work(sandbox: true)
      #   expect(response.body.fetch("data", {}).fetch("work", {}).fetch("put_code", nil)).to eq(put_code)
      #   expect(response.status).to eq(200)
      # end

      it 'orcid_token missing' do
        subject = OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: nil)
        response = subject.update_work(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end

    describe 'delete' do
      # it 'should delete work' do
      #   response = subject.delete_work(sandbox: true)
      #   expect(response.body["data"]).to be_blank
      #   expect(response.body["errors"]).to be_nil
      #   expect(response.status).to eq(204)
      # end

      it 'orcid_token missing' do
        subject = OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: nil)
        response = subject.delete_work(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end
  end

  describe "external_identifier", :order => :defined do
    subject { OrcidClient::ExternalIdentifier.new(type: "GitHub", value: "mfenner", url: "https://github.com/mfenner", orcid: orcid, orcid_token: orcid_token, put_code: "4833") }

    describe 'post' do
      subject { OrcidClient::ExternalIdentifier.new(type: "GitHub", value: "mfenner", url: "https://github.com/mfenner", orcid: orcid, orcid_token: orcid_token) }

      # it 'should create external_identifier' do
      #   response = subject.create_external_identifier(sandbox: true)
      #   expect(response.body["put_code"]).not_to be_blank
      #   expect(response.status).to eq(201)
      # end

      it 'orcid_token missing' do
        subject = OrcidClient::ExternalIdentifier.new(type: "GitHub", value: "mfenner", url: "https://github.com/mfenner", orcid: orcid, orcid_token: nil)
        response = subject.create_external_identifier(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end

    describe 'delete' do
      # it 'should delete external_identifier' do
      #   response = subject.delete_external_identifier(sandbox: true)
      #   expect(response.body["data"]).to be_blank
      #   expect(response.body["errors"]).to be_nil
      #   expect(response.status).to eq(204)
      # end

      it 'orcid_token missing' do
        subject = OrcidClient::ExternalIdentifier.new(type: "GitHub", value: "mfenner", url: "https://github.com/mfenner", orcid: orcid, orcid_token: nil)
        response = subject.delete_external_identifier(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"ORCID access token missing"}])
      end
    end
  end

  describe "notifications", :order => :defined do
    subject { OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: notification_access_token, put_code: "292000", subject: "Request to add a work", intro: "This is an intro", sandbox: true) }

    describe 'post' do
      subject { OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: notification_access_token, subject: "Request to add a work", intro: "This is an intro", sandbox: true) }

      # it 'should create notification' do
      #   response = subject.create_notification(sandbox: true)
      #   expect(response.body["put_code"]).not_to be_blank
      #   expect(response.status).to eq(201)
      # end

      it 'access_token missing' do
        subject = OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: nil)
        response = subject.create_notification(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"Notification access token missing"}])
      end
    end

    describe 'get' do
      # it 'should get notification' do
      #   response = subject.get_notification(sandbox: true)
      #   notification = response.body.fetch("data", {}).fetch("notification", {})
      #   expect(notification["put_code"]).to eq("292000")
      #   expect(notification["items"]["item"]).to eq("item_type"=>"work", "item_name"=>"Omniauth-Orcid: V.1.1.5", "external_id"=>nil)
      #   expect(response.status).to eq(200)
      # end

      it 'access_token missing' do
        subject = OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: nil)
        response = subject.get_notification(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"Notification access token missing"}])
      end
    end

    describe 'delete' do
      # it 'should delete notification' do
      #   response = subject.delete_notification(sandbox: true)
      #   notification = response.body.fetch("data", {}).fetch("notification", {})
      #   expect(notification["put_code"]).to eq("292000")
      #   expect(notification["items"]["item"]).to eq("item_type"=>"work", "item_name"=>"Omniauth-Orcid: V.1.1.5", "external_identifier"=>nil)
      #   expect(response.status).to eq(200)
      # end

      it 'access_token missing' do
        subject = OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: nil)
        response = subject.delete_notification(sandbox: true)
        expect(response.body).to eq("errors"=>[{"title"=>"Notification access token missing"}])
      end
    end
  end
end
