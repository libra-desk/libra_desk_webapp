Rails.application.routes.draw do
  resources :books

  get "up" => "rails/health#show", as: :rails_health_check
end
