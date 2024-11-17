Rails.application.routes.draw do
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  resources :shops do
    resources :users, only: [:new, :create, :edit, :update]
    resources :reviews, only: [:index, :new, :create] do
      member do
        get 'notice'
        get 'survey1'
        get 'survey2'
        post 'submit_survey1'
        post 'submit_survey2'
      end
    end
  end

  root "shops#index"
  match '*path', to: 'application#not_found', via: :all
end
