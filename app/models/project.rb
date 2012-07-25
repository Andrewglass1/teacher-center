class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :percent_funded,
    :school, :stage, :state, :teacher_name, :title, :start_date, :user_id
  belongs_to :user
  has_many :project_tasks
  has_many :tasks, :through => :project_tasks
  after_create :seed_initial_project_tasks
  after_create :seed_initial_donation_log
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

  def seed_initial_donation_log
    donation_logs.create(:amount_funded_cents => 0,:date => start_date)
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
    completed_tasks.order('project_tasks.completed_on ASC')
  end

  def near_end?
    percentage_to_completion_date >= 80
  end

  def completed?
    days_to_end < 0
  end

  def days_to_end
    (expiration_date - Date.today).to_i
  end

  def dollars_needed
    (BigDecimal.new(cost_to_complete_cents.to_s) / 100).to_i
  end

  def percentage_to_completion_date(date = Date.today)
    (date - start_date)/length_of_project
  end

  def dollars_funded
    (BigDecimal.new((goal_cents - cost_to_complete_cents).to_s) / 100).to_i
  end

  def goal_dollars
    (BigDecimal.new(goal_cents.to_s) / 100).to_i
  end

  def donation_chart
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:defaultSeriesType => 'line',
              :zoomType => 'x')
      f.title(:text => 'Donations')
      f.series(:name => 'Goal',
               :data => donation_logs.map { |log| [highcharts_date(log.date), goal_dollars] })
      f.series(:name => 'On Track',
               :data => donation_logs.map { |log| [highcharts_date(log.date), on_track_estimate(log.date)] })
      f.series(:name =>'Total Donations',
               :data => donation_logs.map { |log| [highcharts_date(log.date), log.amount_funded] })
      f.yAxis(:min => 0,
              :max => goal_dollars + 500,
              :title => { :text => 'Amount Funded ($)' })
      f.xAxis(:type => 'datetime',
              :min => highcharts_date(start_date),
              :max => highcharts_date(expiration_date))
      f.tooltip(:valuePrefix => '$',
                :xDateFormat => '%b %e')
      f.legend(layout: 'horizontal')
    end
  end

  def clicks_chart
    LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:zoomType => 'x')
      f.plotOptions(
        :line => {
          :lineWidth => 0
        })
        f.title(:text => 'Tasks')
        f.series(:name => 'All',
                 :data => sorted_completed_dates.map { |date| [highcharts_date(date), all_clicks(date)] },
                 :type => 'areaspline')

        completed_tasks.map(&:task).map(&:medium).uniq.each do |medium|
          f.series(:name => medium,
                   :data => completed_tasks(medium).map { |task| [highcharts_date(task.completed_on), task.clicks] },
                   :type => 'line')
        end
        f.yAxis(:title => { :text => 'Clicks' },
                :min => 0,
                :minRange => 5)
        f.xAxis(:type => 'datetime')
        f.tooltip(:valueSuffix => ' clicks',
                  :xDateFormat => '%b %e')
        f.legend(layout: 'horizontal')
    end
  end

  private

  def highcharts_date(date)
    DateTime.parse(date.to_s).to_i * 1000
  end

  def sorted_completed_dates
    completed_tasks.pluck(:completed_on).uniq.sort
  end

  def all_clicks(date)
    completed_tasks.where(:completed_on => date).map(&:clicks).inject(:+)
  end

  def on_track_estimate(date)
    (goal_dollars * percentage_to_completion_date(date)).round
  end
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
