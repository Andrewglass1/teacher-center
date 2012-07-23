class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:show]
  before_filter :find_project, :confirm_your_project, only: [:show]

  def show
  end

  def create
    if current_user
      @project = current_user.projects.create_by_project_url(params[:project_url])
      redirect_to project_path(@project)
    else
      create_project_for_guest(params)
    end
  end

private

  def create_project_for_guest(params)
    Project.create_in_thread(params[:project_url])
    cookies[:project_url] = params[:project_url]
    redirect_to new_user_registration_path, alert: "You must signup before creating a project"
  end

  def find_project
    @project = Project.find_by_slug(params[:id])
  end

  def confirm_your_project
    unless @project.user == current_user
      redirect_to root_path, notice: "That is not your project"
    end
  end

end
