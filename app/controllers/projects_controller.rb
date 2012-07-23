class ProjectsController < ApplicationController
  before_filter :authenticate_user!, :find_project, :confirm_your_project,
    :create_charts, only: [:show]

  def show
  end

  def create
    if current_user
      @project = current_user.projects.create_by_project_url(
        params[:project_url])
        redirect_to project_path(@project)
    else
      create_project_for_guest(params)
    end
  end

  private

  def create_project_for_guest(params)
    Project.create_in_thread(params[:project_url])
    cookies[:project_url] = params[:project_url]
    redirect_to new_user_registration_path,
      alert: "You must signup before creating a project"
  end

  def find_project
    @project = Project.find_by_slug(params[:id])
  end

  def confirm_your_project
    unless @project.user == current_user
      redirect_to root_path, notice: "That is not your project"
    end
  end

  def create_charts
    @donations_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.chart(:defaultSeriesType => 'line')
      f.title(:text => 'Donations')
      f.series(:name=>'Goal', :data=> Array.new(@project.donation_logs.size, @project.goal_dollars))
      f.series(:name=>'Donations', :data => @project.donation_logs.map(&:amount_funded))
      f.xAxis(
        :categories => @project.donation_logs.map(&:date)
      )
      f.yAxis(
        :min => 0,
        :max => @project.goal_dollars,
        :title => { :text => 'Amount Funded ($)' }
      )

      @clicks_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.chart(:defaultSeriesType => 'line')
        f.title(:text => 'Clicks')
        f.series(:name=>'Clicks', :data => @project.donation_logs.map(&:amount_funded))
        f.xAxis(
          :categories => @project.donation_logs.map(&:date)
        )
        f.yAxis(
          :min => 0,
          :max => @project.goal_dollars,
          :title => { :text => 'Clicks' }
        )
      end
    end
  end

end
