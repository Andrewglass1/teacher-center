class ProjectTasksController < ApplicationController

  def update
    ProjectTask.find(params[:id]).complete
    redirect_to :back
  end

end
