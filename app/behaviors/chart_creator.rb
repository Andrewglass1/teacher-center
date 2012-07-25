class ChartCreator
  attr_accessor :project
  delegate :donation_logs, :log, :goal_dollars, :on_track_estimate,
    :start_date, :expiration_date, :sorted_completed_dates, :all_clicks,
    :completed_tasks, :to => :project

  def initialize(project)
    @project = project
  end

  def donations_chart
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

end

