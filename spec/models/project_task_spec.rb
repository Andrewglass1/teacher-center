require 'spec_helper'

describe ProjectTask do
  let(:project_response) {
    Hashie::Mash.new(
    city: "blah",
    expiration_date: Date.parse("August 2 2012").to_s,
    cost_to_complete: 20,
    donors_choose_id: rand(1000),
    proposal_url: 'http://google.com',
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
    fake_client = double
    DonorsChooseApi::Project.stub(:find_by_id).and_return(project_response)
    Nokogiri.stub(:HTML).and_return(dc_page)
    ProjectTask.any_instance.stub(:bitly_client).and_return(fake_client)
    fake_client.stub(:shorten).and_return(Hashie::Mash.new(short_url: 'http://bit.ly/li2je4'))
    fake_client.stub(:clicks).and_return(Hashie::Mash.new(user_clicks: 5))
    Project.stub(:get_start_date).and_return(Date.today)
  end

  let!(:project) { Project.create_by_project_url('816888') }

  context '#create_short_link' do
    it "creates a bitly url linking to the project's donors choose url after create" do
      project_task = ProjectTask.create(:project_id => project.id)
      project_task.short_url.should include 'bit.ly'
    end
  end

  context '#update_clicks' do
    it "updates the clicks on a project task's short url" do
      project_task = ProjectTask.create(:project_id => project.id)
      project_task.update_clicks
      project_task.clicks.should == 5
    end
  end

end
