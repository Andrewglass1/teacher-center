# @author Andy Glass, Mike Silvis, Andrew Thal 
class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url,
    :percent_funded, :school, :stage, :state, :teacher_name, :title, :start_date

  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  after_create :seed_initial_project_tasks
  after_create :prepare_pdf

  extend FriendlyId
  friendly_id :title, use: :history
  
  # Creates a project 
  # @param [String] project_url from the project page at DonorsChoose
  # @return [Project] returns DonorsChoose project, if no match returns nil
  def self.create_by_project_url(project_url)
    ProjectApiWrapper.create_by_project_url(project_url)
  end

  # Updates attributes of the Project (cost_to_complete & percent_funded)
  # @return [Boolean] returns true if successful update 
  def update_information
    ProjectApiWrapper.update_information(self)
  end

  def prepare_pdf
    PdfGenerator.prepare_pdf(dc_id)
  end

  def pdf_link
    PdfGenerator.pdf_link(dc_id)
  end

  # Projects the amount of time needed to fund a project (with current donation data)
  # @return [Date] returns date that project will be funded
  def projected_fund_date
    if Date.today < expiration_date && percent_funded < 100 && !projected_days_of_funding_needed.infinite?
      Date.parse((start_date + projected_days_of_funding_needed).to_s)
    end
  end

  # Determines if a project will be funded prior to the expiration date
  # @return [Boolean] returns true if projected_fund_date falls after expiration_date.
  def off_track?
    projected_fund_date > expiration_date if projected_fund_date
  end


  def seed_initial_project_tasks
    Task.all.each do |task|
      project_tasks.create(:task_id => task.id)
    end
  end

  def tasks_to_do
    project_tasks.find(
      :all,
      :conditions => ["completed = ?", false],
      :joins => 'JOIN tasks on tasks.id = project_tasks.task_id',
      :order => 'tasks.medium ASC',
    )
    # project_tasks.where(:completed => false).sort{ |pt| puts pt.task.medium.to_s }
  end

  def tasks_completed
    project_tasks.where(:completed => true)
  end

  def task_to_do(medium)
    project_tasks.where(:completed => false).find{ |pt| pt.task.medium == medium }
  end

  def completed_tasks(medium)
    project_tasks.where(:completed => true).select { |pt| pt.task.medium == medium }
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
