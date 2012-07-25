require 'spec_helper'

describe "project helpers" do
  include ProjectsHelper
  
  describe "#display_fund_date" do
    let!(:project)   { FactoryGirl.create :project}
    let!(:today)     { Date.today }
    
    before(:each) do
      Project.any_instance.stub(:projected_fund_date).and_return(today)
    end
    
    it "returns a nicely formatted date string for projected funded date" do
      expected_formated_date = today.strftime("%n %B %d, %Y")
      display_fund_date(project).should == "Projected to be Funded on: #{expected_formated_date}"
    end
  end
end