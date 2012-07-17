class ProjectsController < ApplicationController

  def show 
    @project = Project.find_by_id(params[:id])
  end 

  def create
    @project = Project.create_by_project_url(params["project_url"])
    if @project
      redirect_to project_path(@project)
    else
      redirect_to root_path, :notice => "Please input a valid project url"
    end
  end
end
