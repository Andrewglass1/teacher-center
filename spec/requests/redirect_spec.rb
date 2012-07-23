require 'spec_helper'

class Project
  def self.create_in_thread(project_url)
    Project.create_by_project_url(project_url)
  end
end
describe "When they paste a url and are" do
  let(:donors_url) { "809357"}
  let(:previous_user) { FactoryGirl.create(:user) }

  context "not logged in it creates the project after" do
    let(:new_user) { FactoryGirl.build(:user) }
    it "they sign up" do
      Project.destroy_all
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      PagesController.any_instance.stub(:project).and_return(Project.last)
      signup(new_user)
      page.should have_content "days left"
    end
    it "they login" do
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      click_link "Sign in"
      PagesController.any_instance.stub(:project).and_return(Project.last)
      login(previous_user)
      page.should have_content "days left"
    end
  end
  context "logged in" do
    it "creates the project" do
      visit new_user_session_path
      login(previous_user)
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      page.should have_content "days left"
    end
  end
  context "a user has an account and is logging back in" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:project) { Project.create_by_project_url("809357") }
    it "redirects them to their lastest project" do
      user.projects << project
      visit root_path
      click_link "Login"
      login(user)
      page.should have_content project.title
    end
  end
end