class PagesController < ApplicationController
  before_filter :create_project_if_session

  def welcome

  end

private

  def project_url
    cookies[:project_url]
  end

  def create_project_if_session
    # raise project_url.inspect
    if project_url && current_user
      @project = current_user.projects.create_by_project_url(project_url)
      cookies.delete(:project_url)
      if @project
        redirect_to project_path(@project)
      else
        redirect_to root_path, :notice => "Please input a valid project url"
      end
    end
  end

end
