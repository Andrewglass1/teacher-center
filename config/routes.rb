Teachercenter::Application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :project_tasks
    end
  end

  resources :projects
  root :to => "pages#welcome"
  match '/letter' => 'project_tasks#letter'
end
