require 'spec_helper'

describe DonationLog do

  let!(:donation_log) { DonationLog.create(:project_id => 1, :date =>Date.today, :amount_funded_cents => 5000) }
  let!(:donation_log2) { DonationLog.create(:project_id => 1, :date =>Date.today-2, :amount_funded_cents => 2000) }
  let!(:donation_log3) { DonationLog.create(:project_id => 1, :date =>Date.today-200, :amount_funded_cents => 1000) }

  before do
    ProjectApiWrapper.unstub(:log_donations)
  end

  context '#donations_today_cents' do
    it "gives the donations (in cents) given in that day for the specified project id" do
      DonationLog.donations_today_cents(1).should == 5000
    end
  end

  context "#donations_over_days_cents" do
    context "the project has donation logs over multiple days" do
      it "provides the sum of donations from the specified project over the specified date range" do
        DonationLog.donations_over_days_cents(1,3).should == 7000
      end
    end
  end


end
