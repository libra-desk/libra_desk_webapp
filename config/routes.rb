Rails.application.routes.draw do
  resources :books
  resources :students
  resources :borrowings

  get '/signup', to: 'sessions#new_signup'
  post '/signup', to: 'sessions#signup'

  get '/login', to: 'sessions#new_login'
  post '/login', to: 'sessions#login'

  get "up" => "rails/health#show", as: :rails_health_check
end
