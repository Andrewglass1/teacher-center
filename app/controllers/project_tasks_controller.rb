class ProjectTasksController < ApplicationController

  def letter
    params[:copy] = params[:copy].gsub("\n", "<br>")
    render :layout => false
  end
end