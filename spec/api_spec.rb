require 'spec_helper'

describe OrcidClient, vcr: true do
  let(:doi) { "10.5281/zenodo.59983"}
  let(:orcid) { "0000-0001-6528-2027" }
  let(:access_token) { ENV['ACCESS_TOKEN'] }
  let(:notification_access_token) { ENV['NOTIFICATION_ACCESS_TOKEN'] }
  let(:put_code) { "740616" }
  let(:fixture_path) { "spec/fixtures/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token, put_code: put_code) }

  describe "works", :order => :defined do
    describe 'post' do
      subject { OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: access_token) }

      it 'should create work' do
        response = subject.create_work(sandbox: true)
        expect(response["put_code"]).not_to be_blank
      end
    end

    describe 'get' do
      it 'should get works' do
        response = subject.get_works(sandbox: true)
        works = response.fetch("data", {}).fetch("group", {})
        expect(works.length).to eq(27)
        work = works.first
        expect(work["external-ids"]).to eq("external-id"=>[{"external-id-type"=>"doi", "external-id-value"=>"10.5167/UZH-19531", "external-id-url"=>nil, "external-id-relationship"=>"SELF"}])
      end
    end

    describe 'put' do
      it 'should update work' do
        response = subject.update_work(sandbox: true)
        expect(response.fetch("data", {}).fetch("work", {}).fetch("put_code", nil)).to eq(put_code)
      end
    end

    describe 'delete' do
      it 'should delete work' do
        response = subject.delete_work(sandbox: true)
        expect(response["data"]).to be_blank
        expect(response["errors"]).to be_nil
      end
    end
  end

  describe "notifications" do
    subject { OrcidClient::Notification.new(doi: doi, orcid: orcid, notification_access_token: notification_access_token, subject: "Request to add a work", intro: "This is an intro", sandbox: true) }

    describe 'post' do
      it 'should create notification' do
        response = subject.create_notification(sandbox: true)
        expect(response["put_code"]).not_to be_blank
      end
    end
  end
end
