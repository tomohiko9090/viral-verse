Rails.application.routes.draw do
  root "shops#index"

  resources :shops do
    resources :reviews, only: [:index, :new, :create] do
      member do
        get 'notice'
      end
    end
  end
end
