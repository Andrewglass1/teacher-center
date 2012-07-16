class ProjectsController < ApplicationController

  def show
    @project = Project.find_by_id(params[:id])
  end
end
