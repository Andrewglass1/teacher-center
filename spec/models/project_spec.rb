require 'spec_helper'

describe Project do
  context ".create_by_project_url" do
    let(:project_response) { 
      Hashie::Mash.new(
      city: "blah",
      expiration_date: Date.today.to_s,
      cost_to_complete: BigDecimal.new(rand(1000).to_s, 2),
      donors_choose_id: rand(1000),
      proposal_url: Faker::Internet.domain_name,
      short_description: Faker::Lorem.words(5).join(' '),
      fund_url: Faker::Internet.domain_name,
      total_price: BigDecimal.new(rand(1000).to_s, 2),
      image_url: Faker::Internet.domain_name,
      on_track: true,
      percent_funded: rand(100),
      school_name: Faker::Lorem.words(2).join(' '),
      stage: 'initial',
      state: Faker::Lorem.words(1).join(' '),
      teacher_name: Faker::Lorem.words(1).join(' '),
      title: Faker::Lorem.words(1).join(' ')
    )}

    before do
      DonorsChooseApi::Project.stub(:find_by_url).and_return(project_response)
      Project.stub(:get_start_date).and_return(Date.today)
    end

    context "when given a valid project url" do
      let(:valid_url){ 'http://www.donorschoose.org/project/biotechnology-applications/816888/'}
      let(:completed_valid_url){ 'http://www.donorschoose.org/donors/proposal.html?id=88850'}
      it "creates a project with all valid attributes" do
        expect { Project.create_by_project_url(valid_url) }.to change{Project.count}.by(1)
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
    let!(:dc_page) { Nokogiri::HTML(open(Rails.root + 'spec/support/donors_choose.html')) }
    it "retrieves the start date of the project when given the id" do
      Nokogiri.stub(:HTML).and_return(dc_page)
      Project.get_start_date(dc_url).should == Date.parse("26 Jun 2012")
    end
  end

  # context ".dollars_into_cents" do
  #   it "converts a dollar "
end
