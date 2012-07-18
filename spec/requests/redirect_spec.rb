require 'spec_helper'

describe "When they paste a url and are" do
  context "not logged in" do
    context "They sign up" do

    end
    context "they login" do

    end
  end
  context "logged in" do
    let(:donors_url) { "http://www.donorschoose.org/project/warriors-dont-cry-an-autobiography-to/809357/"}
    it "creates the project and redirects them to the project" do
      visit root_path
      fill_in "project_url"
      save_and_open_page
      click_on "comit"
    end
  end
end
