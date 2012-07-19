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
  let(:pdf_response) {
    "My students need twenty-five copies of Shades of Gray, five copies of Number \nthe Stars, and five copies of Bull Run.
     What did your social studies instruction \nlook like in school? Do you remember lectures? How about those black and wh
     ite \nvideos? I want to make social studies interactive and fun all while...\nFIND OUT HOW YOU CAN HELP:http://bit.ly/M
     BkJ4a\nThis project is made possible by DonorsChoose, an online charity that \nmakes it easy for anyone to help student
     s in need.\nHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social S
     tudies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lock
     ett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit
     .ly/MBkJ4aHelp Ms. Lockett's students Social Studies ALIVE!!!http://bit.ly/MBkJ4aHelp Ms. Lockett's students Social Stu
     dies ALIVE!!!http://bit.ly/MBkJ4a"
  }

  before do
    fake_client = double
    DonorsChooseApi::Project.stub(:find_by_id).and_return(project_response)
    Nokogiri.stub(:HTML).and_return(dc_page)
    UrlShortener.stub(:client).and_return(fake_client)
    fake_client.stub(:shorten).and_return(Hashie::Mash.new(short_url: 'http://bit.ly/li2je4'))
    fake_client.stub(:clicks).and_return(Hashie::Mash.new(user_clicks: 5))
    Project.stub(:get_start_date).and_return(Date.today)
    ProjectApiWrapper.stub(:log_donations).and_return(true)
    PdfGenerator.stub(:pdf_reader).and_return(pdf_response)
  end

  let!(:project) { Project.create_by_project_url('816888') }
  let(:task) {Task.create(medium: "Twitter")}
  let!(:project_task) { ProjectTask.create({project_id: project.id, task_id: task.id})}
  
  context '#get_short_link' do
    it "creates a bitly url linking to the project's donors choose url after create" do
      project_task.short_url.should include 'bit.ly'
    end
  end

  context '#update_clicks' do
    it "updates the clicks on a project task's short url" do
      project_task.update_clicks
      project_task.clicks.should == 5
    end
  end

  context '#completed' do
    it "completes the task, saves the time it was completed, and stores the description" do
      task = Task.create()
      project_task.complete
      project_task.completed.should == true
      project_task.completed_on.should == Date.today
      project_task.read_attribute(:description).should be
    end
  end

  context '#description' do
    context "the project has not yet been completed" do
      it "returns a different description based off of the project's state" do
        project_task.read_attribute(:description).should be_nil

        Project.any_instance.stub(:near_end?).and_return(true)
        project_task.description.should include("ending")

        Project.any_instance.unstub(:near_end?)
        Project.any_instance.stub(:near_end?).and_return(false)
        Project.any_instance.stub(:off_track?).and_return(true)
        project_task.description.should include("help")

        project_task.project.stub(:near_end?).and_return(false)
        Project.any_instance.unstub(:off_track?)
        Project.any_instance.stub(:off_track?).and_return(false)
        project_task.description.should include("Check out")
      end

      context "the project has been completed" do
        it "returns the saved description from the database, not based off of the current state" do
          project_task.update_attributes({:completed => true, :description => "fake description"})
          project_task.description.should == "fake description"
        end
      end
    end
  end

end
