class ProjectTasksController < ApplicationController
  def letter
    params[:copy].gsub!("\n", "<br>")
    render :layout => false
  end
end
