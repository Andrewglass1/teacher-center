class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :on_track,
    :percent_funded, :school, :stage, :state, :teacher_name, :title, :start_date

  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  after_create :prepare_pdf

  def self.create_by_project_url(project_url)
    ProjectApiWrapper.create_by_project_url(project_url)
  end

  def update_information
    ProjectApiWrapper.update_information(self)
  end

  def prepare_pdf
    PdfGenerator.prepare_pdf(dc_id)
  end

  def pdf_link
    PdfGenerator.pdf_link(dc_id)
  end

  def projected_fund_date
    if Date.today < expiration_date
      Date.parse((start_date + projected_days_of_funding_needed).to_s)
    else
      expiration_date
    end
  end

  # def rabble
  #   Date.today < expiration_date ? Date.parse((start_date + projected_days_of_funding_needed).to_s) : expiration_date
  # end

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