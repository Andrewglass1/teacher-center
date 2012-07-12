require 'spec_helper'

describe Project do
let(:project_response) { 
    Hashie::Mash.new(
    city: "blah",
    expiration_date: Date.parse("August 2 2012").to_s,
    cost_to_complete: 20,
    donors_choose_id: rand(1000),
    proposal_url: Faker::Internet.domain_name,
    short_description: Faker::Lorem.words(5).join(' '),
    fund_url: Faker::Internet.domain_name,
    total_price: 100,
    image_url: Faker::Internet.domain_name,
    on_track: true,
    percent_funded: 80,
    school_name: Faker::Lorem.words(2).join(' '),
    stage: 'initial',
    state: Faker::Lorem.words(1).join(' '),
    teacher_name: Faker::Lorem.words(1).join(' '),
    title: Faker::Lorem.words(1).join(' ')
  )}
  let!(:dc_page) { Nokogiri::HTML(open(Rails.root + 'spec/support/donors_choose.html')) }

  before do
    DonorsChooseApi::Project.stub(:find_by_id).and_return(project_response)
    Nokogiri.stub(:HTML).and_return(dc_page)
  end

  context ".create_by_project_url" do
    before { Project.stub(:get_start_date).and_return(Date.today) }

    context "when given a valid project url" do
      let(:valid_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
      let(:completed_valid_url){ 'http://www.donorschoose.org/donors/proposal.html?id=88850'}
      it "creates a project" do
        expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(1)
        project_response.donors_choose_id += 1
        expect { Project.create_by_project_url(completed_valid_url) }.to change{Project.count}.by(1)
      end

      context "that project is already in the database" do
        it "does not create a new project" do
          Project.create_by_project_url(valid_url)
          expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(0)
        end
      end
    end

    context "when given an invalid url" do
      let(:invalid_url) { "http://google.com"}
      it "does not create a project" do
        expect { Project.create_by_project_url(invalid_url) }.to change{Project.count}.by(0)
      end
    end
  end

  context ".get_start_date" do
    let(:dc_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
    it "retrieves the start date of the project when given the id" do
      Project.get_start_date(dc_url).should == Date.parse("26 Jun 2012")
    end
  end

  context "#projected_fund_date" do
    let(:project) { Project.create_by_project_url('816888') }
    before do
     Project.stub(:get_start_date).and_return(Date.today)
     Project.any_instance.stub(:start_date).and_return(Date.parse('July 1 2012'))
     Date.stub(:today).and_return(Date.parse('July 12 2012'))
    end

    context "the project is live" do
      it "returns the projected fund date" do
        project.projected_fund_date.should == Date.parse('July 14 2012')
      end
    end

    context "the project has been funded but has not yet ended" do
      it "returns today's date" do
        project.update_attribute(:percent_funded, 100)
        project.projected_fund_date.should == Date.parse('July 12 2012')
      end
    end

    context "the project has ended" do
      it "returns the expiration date" do
        project.update_attribute(:expiration_date, Date.parse('July 4 2012'))
        project.projected_fund_date.should == Date.parse('July 4 2012')
      end
    end

  end
end
