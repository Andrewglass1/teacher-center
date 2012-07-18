class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_project, :confirm_your_project, only: [:show]

  def show
  end

  def create
    @project = current_user.projects.create_by_project_url(params["project_url"])
    if @project
      redirect_to project_path(@project)
    else
      redirect_to root_path, :notice => "Please input a valid project url"
    end
  end

private

  def find_project
    @project = Project.find_by_slug(params[:id])
  end

  def confirm_your_project
    redirect_to root_path, notice: "That is not your project" unless @project.user == current_user
  end

end
