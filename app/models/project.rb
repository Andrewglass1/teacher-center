class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :on_track,
    :percent_funded, :school, :stage, :state, :teacher_name, :title, :start_date

  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  after_create :generate_print_and_share

  def self.create_by_project_url(project_url)
    if project_match = project_url.match(/(\d{5,6})/)
      project_id = project_match[1]
      if project = DonorsChooseApi::Project.find_by_id(project_id)
        Project.find_or_create_by_dc_id(build_project(project))
      end
    end
  end

  def self.dollars_into_cents(dollars)
    (BigDecimal.new(dollars.to_s) * 100).to_i
  end

  def projected_fund_date
    if Date.today < expiration_date
      Date.parse((start_date + projected_days_of_funding_needed).to_s)
    else
      expiration_date
    end
  end

  def update_information
    project_info = DonorsChooseApi::Project.find_by_id(dc_id)
    update_attributes({
      :cost_to_complete_cents => Project.dollars_into_cents(project_info.cost_to_complete),
      :percent_funded => project_info.percent_funded
    })
  end

  ## First you have to visit the URL.
  def generate_print_and_share
    Thread.new do
      Faraday.get("http://printandshare.org/proposals/view/#{dc_id}")
    end
  end

  def print_and_share_pdf_url
    "http://printandshare.org/proposals/pdf/#{dc_id}"
  end

private

  def percentage_to_completion_date
    (Date.today - start_date)/length_of_project
  end

  def length_of_project
    expiration_date - start_date
  end

  def projected_days_of_funding_needed
    percentage_to_completion_date/(percent_funded.to_f/100) * length_of_project
  end



end
