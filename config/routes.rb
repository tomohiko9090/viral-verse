Rails.application.routes.draw do
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :shops do
    resources :reviews, only: [:index, :new, :create] do
      member do
        get 'notice'
      end
    end
  end

  root "shops#index"
  match '*path', to: 'application#not_found', via: :all
end
