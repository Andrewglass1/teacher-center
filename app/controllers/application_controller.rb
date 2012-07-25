class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    if (request.referer == sign_in_url)
      current_user.projects.last ? project_path(current_user.projects.last) : super
    elsif (request.referer == sign_up_url)
      super
    else
      request.referer || stored_location_for(resource) || root_path
    end
  end

  private

  def sign_in_url
    url_for(
      :action => 'new',
      :controller => 'sessions',
      :only_path => false,
      :protocol => 'http'
    )
  end

  def sign_up_url
    url_for(
      :action => 'new',
      :controller => 'registrations',
      :only_path => false,
      :protocol => 'http'
    )
  end
end
