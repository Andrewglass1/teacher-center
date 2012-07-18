class Api::V1::ProjectTasksController < ApplicationController
  respond_to :json

  def update
    respond_with ProjectTask.find(params[:id]).complete
  end

end
