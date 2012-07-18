Teachercenter::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :project_tasks
    end
  end
  resources :projects
  root :to => "pages#welcome"
end
