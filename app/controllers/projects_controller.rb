# @author Mary Cutrali, Mike Silvis, Andy Glass, Andrew Thal
class ProjectsController < ApplicationController
  # GET /projects/:id(.:format)  
  def show
    @project = Project.find_by_slug(params[:id])
  end

  # POST /projects(.:format) 
  def create
    @project = Project.create_by_project_url(params["project_url"])
    if @project
      redirect_to project_path(@project)
    else
      redirect_to root_path, :notice => "Please input a valid project url"
    end
  end

end
