require 'spec_helper'

describe Project do
  context ".create_by_project_url" do
    let(:project_response) { Hashie::Mash.new(city: "blah", expiration_date: Date.today.to_s) }
    before { DonorsChooseApi::Project.stub(:find_by_url).and_return(project_response) }
    context "when given a valid project url" do
      let(:valid_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
      it "creates a project with all valid attributes" do
        expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(1)
      end
    end
    context "when given an invalid url" do
      let(:invalid_url) { "http://google.com"}
      it "creates a project with invalid attributes" do
        pending
        # expect { Project.create_by_project_url(invalid_url) }.to change{Project.count}.by(0)
      end
    end
  end
end
