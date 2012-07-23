class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :percent_funded,
    :school, :stage, :state, :teacher_name, :title, :start_date, :user_id
  belongs_to :user
  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  after_create :seed_initial_project_tasks
  has_many :donation_logs
  has_many :click_logs
  validates_uniqueness_of :dc_id


  extend FriendlyId
  friendly_id :title, use: :history

  def self.create_by_project_url(project_url)
    ProjectApiWrapper.create_by_project_url(project_url)
  end

  def self.create_in_thread(project_url)
    Thread.new { Project.create_by_project_url(project_url) }
  end

  def update_information
    ProjectApiWrapper.update_information(self)
  end

  def log_project_clicks
    todays_click_log       = click_logs.find_or_create_by_date(Date.today)
    current_total_clicks   = project_tasks.sum(&:clicks)
    todays_clicks          = current_total_clicks - click_total_yesterday
    todays_click_log.update_attributes(:daily_clicks => todays_clicks,
                                       :total_clicks_to_date => current_total_clicks)
  end

  def click_total_yesterday
    yesterdays_click_log   = click_logs.find_by_date(Date.today-1) || nil
    yesterdays_click_log ? yesterdays_click_log.total_clicks_to_date : 0
  end

  def pdf_link
    PdfGenerator.pdf_link(dc_id)
  end

  def projected_fund_date
    if not_expired && not_funded && !projected_days_of_funding_needed.infinite?
      Date.parse((start_date + projected_days_of_funding_needed).to_s)
    end
  end

  def off_track?
    projected_fund_date > expiration_date if projected_fund_date
  end

  def seed_initial_project_tasks
    Task.all.each do |task|
      project_tasks.create(:task_id => task.id)
    end
  end

  def tasks_to_do
    project_tasks.where(
      completed: false).includes(:task).order('tasks.medium ASC')
  end

  def completed_tasks(medium = nil)
    all_completed = project_tasks.includes(:task).where(:completed => true)
    completed_tasks = if medium.nil?
                        all_completed
                      else
                        all_completed.where(:tasks => { :medium => medium })
                      end
    completed_tasks.order('project_tasks.updated_at DESC').to_a
  end

  def near_end?
    percentage_to_completion_date >= 80
  end

  def days_to_end
    (expiration_date - Date.today).to_i
  end

  def dollars_needed
    (BigDecimal.new(cost_to_complete_cents.to_s) / 100).to_i
  end

  def percentage_to_completion_date
    (Date.today - start_date)/length_of_project
  end

  def dollars_funded
    (BigDecimal.new(goal_cents - cost_to_complete_cents) / 100).to_i
  end

  def goal_dollars
    (BigDecimal.new(goal_cents) / 100).to_i
  end

  private

  def length_of_project
    expiration_date - start_date
  end

  def projected_days_of_funding_needed
    percentage_to_completion_date/(percent_funded.to_f/100) * length_of_project
  end

  def not_expired
    Date.today < expiration_date

  end

  def not_funded
    percent_funded < 100
  end
end
