class ProjectsController < ApplicationController

  def create 
    @project = Project.new 
    project.save
  end 


  def show 
    @project = Project.find_by_id(params[:id])
  end 
end
