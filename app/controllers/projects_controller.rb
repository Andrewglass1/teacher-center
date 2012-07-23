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
    @donations_charts = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart][:defaultSeriesType] = "area"
      f.series(:name=>'John', :data=>[3, 20, 3, 5, 4, 10, 12 ,3, 5,6,7,7,80,9,9])
      f.series(:name=>'Jane', :data=> [1, 3, 4, 3, 3, 5, 4,-46,7,8,8,9,9,0,0,9] )
    end
  end

end
