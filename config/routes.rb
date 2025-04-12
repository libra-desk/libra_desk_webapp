Rails.application.routes.draw do
  resources :books
  resources :students
  resources :borrowings do
    member do
      post 'return', to: 'borrowings#return_book', as: :return
      post '/borrowed_books', to: 'borrowings#borrowed_books'
    end
  end

  get 'borrowed_books', to: 'borrowings#borrowed_books_view' 

  get '/signup', to: 'sessions#new_signup'
  post '/signup', to: 'sessions#signup'

  get '/login', to: 'sessions#new_login'
  post '/login', to: 'sessions#login'

  delete '/signout', to: 'sessions#signout', as: :signout

  get "up" => "rails/health#show", as: :rails_health_check
end
