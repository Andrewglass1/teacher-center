Teachercenter::Application.routes.draw do
  devise_for :users

  resources :projects 
  root :to => "pages#welcome"
end