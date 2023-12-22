require "spec_helper"

describe OrcidClient::Work, vcr: true do
  let(:doi) { "10.5438/h5xp-x178" }
  let(:orcid) { "0000-0001-6528-2027" }
  let(:orcid_token) { ENV["ORCID_TOKEN"] }
  let(:fixture_path) { "spec/fixtures/" }
  let(:samples_path) { "resources/record_3.0/samples/read_samples/" }

  subject { OrcidClient::Work.new(doi: doi, orcid: orcid, orcid_token: orcid_token) }

  describe "work type" do
    it "Text, Article" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Article"
      expect(subject.type).to eq("journal-article")
    end
    it "Text, Book" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Book"
      expect(subject.type).to eq("book")
    end
    it "Text, chapter" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "chapter"
      expect(subject.type).to eq("book-chapter")
    end
    it "Text, Project report" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Project report"
      expect(subject.type).to eq("report")
    end
    it "Text, Dissertation" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Dissertation"
      expect(subject.type).to eq("dissertation-thesis")
    end
    it "Text, Conference Abstract" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Conference Abstract"
      expect(subject.type).to eq("conference-abstract")
    end
    it "Text, Conference full text" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "Conference full text"
      expect(subject.type).to eq("conference-paper")
    end
    it "Text, poster" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "poster"
      expect(subject.type).to eq("conference-poster")
    end
    it "Text, working paper" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "working paper"
      expect(subject.type).to eq("working-paper")
    end
    it "Text, dataset" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = "dataset"
      expect(subject.type).to eq("data-set")
    end
    it "Collection, Collection of Datasets" do
      subject.metadata.types["resourceTypeGeneral"] = "Collection"
      subject.metadata.types["resourceType"] = "Collection of Datasets"
      expect(subject.type).to eq("other")
    end
    it "Collection, Report" do
      subject.metadata.types["resourceTypeGeneral"] = "Collection"
      subject.metadata.types["resourceType"] = "Report"
      expect(subject.type).to eq("report")
    end
    it "Audiovisual" do
      subject.metadata.types["resourceTypeGeneral"] = "Audiovisual"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Collection" do
      subject.metadata.types["resourceTypeGeneral"] = "Collection"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Dataset" do
      subject.metadata.types["resourceTypeGeneral"] = "Dataset"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("data-set")
    end
    it "Event" do
      subject.metadata.types["resourceTypeGeneral"] = "Event"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Image" do
      subject.metadata.types["resourceTypeGeneral"] = "Image"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "InteractiveResource" do
      subject.metadata.types["resourceTypeGeneral"] = "InteractiveResource"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Model" do
      subject.metadata.types["resourceTypeGeneral"] = "Model"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "PhysicalObject" do
      subject.metadata.types["resourceTypeGeneral"] = "PhysicalObject"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("physical-object")
    end
    it "Service" do
      subject.metadata.types["resourceTypeGeneral"] = "Service"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Software" do
      subject.metadata.types["resourceTypeGeneral"] = "Software"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("software")
    end
    it "Sound" do
      subject.metadata.types["resourceTypeGeneral"] = "Sound"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Text" do
      subject.metadata.types["resourceTypeGeneral"] = "Text"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Workflow" do
      subject.metadata.types["resourceTypeGeneral"] = "Workflow"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Other" do
      subject.metadata.types["resourceTypeGeneral"] = "Other"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Film" do
      subject.metadata.types["resourceTypeGeneral"] = "Film"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Book" do
      subject.metadata.types["resourceTypeGeneral"] = "Book"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("book")
    end
    it "BookChapter" do
      subject.metadata.types["resourceTypeGeneral"] = "BookChapter"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("book-chapter")
    end
    it "ComputationalNotebook" do
      subject.metadata.types["resourceTypeGeneral"] = "ComputationalNotebook"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("software")
    end
    it "ConferencePaper" do
      subject.metadata.types["resourceTypeGeneral"] = "ConferencePaper"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("conference-paper")
    end
    it "ConferenceProceeding" do
      subject.metadata.types["resourceTypeGeneral"] = "ConferenceProceeding"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "DataPaper" do
      subject.metadata.types["resourceTypeGeneral"] = "DataPaper"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "Dissertation" do
      subject.metadata.types["resourceTypeGeneral"] = "Dissertation"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("dissertation-thesis")
    end
    it "Journal" do
      subject.metadata.types["resourceTypeGeneral"] = "Journal"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "JournalArticle" do
      subject.metadata.types["resourceTypeGeneral"] = "JournalArticle"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("journal-article")
    end
    it "OutputManagementPlan" do
      subject.metadata.types["resourceTypeGeneral"] = "OutputManagementPlan"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("data-management-plan")
    end
    it "PeerReview" do
      subject.metadata.types["resourceTypeGeneral"] = "PeerReview"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("review")
    end
    it "Preprint" do
      subject.metadata.types["resourceTypeGeneral"] = "Preprint"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("preprint")
    end
    it "Report" do
      subject.metadata.types["resourceTypeGeneral"] = "Report"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("report")
    end
    it "Standard" do
      subject.metadata.types["resourceTypeGeneral"] = "Standard"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("standards-and-policy")
    end
    it "Instrument " do
      subject.metadata.types["resourceTypeGeneral"] = "Instrument "
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
    it "StudyRegistration" do
      subject.metadata.types["resourceTypeGeneral"] = "StudyRegistration"
      subject.metadata.types["resourceType"] = nil
      expect(subject.type).to eq("other")
    end
  end
end
