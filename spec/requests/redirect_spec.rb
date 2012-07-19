require 'spec_helper'

describe "When they paste a url and are" do
  let(:donors_url) { "809357"}
  let(:previous_user) { FactoryGirl.create(:user) }

  context "not logged in it creates the project after" do
    let(:new_user) { FactoryGirl.build(:user) }
    it "they sign up" do
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      PagesController.any_instance.stub(:project_url).and_return(donors_url)
      signup(new_user)
      page.should have_content "There are 14 days left to fund your project"
    end
    it "they login" do
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      PagesController.any_instance.stub(:project_url).and_return(donors_url)
      click_link "Sign in"
      login(previous_user)
      page.should have_content "There are 14 days left to fund your project"
    end
  end
  context "logged in" do
    it "creates the project" do
      visit new_user_session_path
      login(previous_user)
      visit root_path
      fill_in "project_url", with: donors_url
      click_link_or_button "Get Started!"
      page.should have_content "There are 14 days left to fund your project"
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
