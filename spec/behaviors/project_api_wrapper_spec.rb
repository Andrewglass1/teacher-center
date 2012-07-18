require 'spec_helper'

describe ProjectApiWrapper do
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

  let(:project_response2) {
    Hashie::Mash.new(
    city: "blah",
    expiration_date: Date.parse("August 2 2012").to_s,
    cost_to_complete: 10,
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
    ProjectApiWrapper.stub(:open_page).and_return(dc_page)
    ProjectApiWrapper.stub(:log_donations).and_return(true)
  end

  context ".log_donations" do
    let!(:project) { Project.create_by_project_url('816888') }

    context "a project has no donation logs for the current date" do
      it "creates a new donation log since there not one for the date " do
        ProjectApiWrapper.unstub(:log_donations)
        expect { ProjectApiWrapper.log_donations(project_response, project) }.to change{project.donation_logs.count}.by(1)
      end
    end

    context "a project already has a donation log for the current date" do
      it "updates the previous log and does not create a new one" do
        ProjectApiWrapper.unstub(:log_donations)
        ProjectApiWrapper.log_donations(project_response, project)
        expect { ProjectApiWrapper.log_donations(project_response2, project) }.to change{project.donation_logs.count}.by(0)
        project.donation_logs.first.amount_funded_cents.should == 9000
      end
    end

  end

end