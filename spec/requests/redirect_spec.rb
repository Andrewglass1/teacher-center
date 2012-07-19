require 'spec_helper'

class Project
  def self.create_in_thread(project_url)
    Project.create_by_project_url(project_url)
  end
end

describe "When they paste a url and are" do
  let(:previous_user) { FactoryGirl.create(:user) }
  let(:project_response) {
    Hashie::Mash.new(
    city: "blah",
    expiration_date: Date.parse("August 2 2012").to_s,
    cost_to_complete: 20,
    donors_choose_id: rand(10000..999999),
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
  let(:donors_url) { project_response.donors_choose_id.to_s }
  let!(:dc_page) { Nokogiri::HTML(open(Rails.root + 'spec/support/donors_choose.html')) }

  before do
    DonorsChooseApi::Project.stub(:find_by_id).and_return(project_response)
    ProjectApiWrapper.stub(:open_page).and_return(dc_page)
    Project.stub(:create_in_thread).and_return(true)
  end

  context "not logged in it creates the project after" do
    let(:new_user) { FactoryGirl.build(:user) }
    it "they sign up" do
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      PagesController.any_instance.stub(:project_url).and_return(donors_url)
      signup(new_user)
      page.should have_content "There are 13 days left to fund your project"
    end
    it "they login" do
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      PagesController.any_instance.stub(:project_url).and_return(donors_url)
      click_link "Sign in"
      login(previous_user)
      page.should have_content "There are 13 days left to fund your project"
    end
  end
  context "logged in" do
    it "creates the project" do
      visit new_user_session_path
      login(previous_user)
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      page.should have_content "There are 13 days left to fund your project"
    end
  end
  context "a user has an account and is logging back in" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:project) { FactoryGirl.create(:project, user_id: user.id)}
    it "redirects them to their lastest project" do
      visit root_path
      click_link "Login"
      login(user)
      page.should have_content project.title
    end
  end

end