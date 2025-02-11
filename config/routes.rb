Rails.application.routes.draw do
  # セッション関連
  controller :sessions do
    get '/login' => :new, as: :login
    post '/login' => :create
    delete '/logout' => :destroy, as: :logout
  end

  # 店舗関連
  resources :shops do
    # ユーザー管理
    resources :users, except: [:index, :show]

    # レビュー関連
    resources :reviews, only: [:index, :new, :create] do
      member do
        scope module: :reviews do  # または namespace :reviews do
          get :notice
          get :survey1
          get :survey2
          post :submit_survey1
          post :submit_survey2
        end
      end
    end
  end

  root "shops#index"
  match '*path', to: 'application#not_found', via: :all

  # MEMO: 以下とGemfileのerd_mapをコメントアウトし、bundle exec rails erd_mapを実行する
  # mount ErdMap::Engine => "erd_map"
end
