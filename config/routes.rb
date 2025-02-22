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
    resources :reviews, only: [:index, :create] do
      collection do
        get 'new(/:locale)', to: 'reviews#new', as: :localized_new
      end
      member do
        scope '(:locale)', locale: /en|ja/ do
          # ロケール付きのURLが生成できないため、as: :localized_notice を定義している
          # 例) localized_notice_shop_review_path(@shop, @review, locale: params[:locale])
          get 'notice', to: 'reviews#notice', as: :localized_notice
          get 'survey1', to: 'reviews#survey1', as: :localized_survey1
          get 'survey2', to: 'reviews#survey2', as: :localized_survey2
          post 'submit_survey1', to: 'reviews#submit_survey1', as: :localized_submit_survey1
          post 'submit_survey2', to: 'reviews#submit_survey2', as: :localized_submit_survey2
        end
      end
    end
  end

  root "shops#index"
  match '*path', to: 'application#not_found', via: :all

  # MEMO: 以下とGemfileのerd_mapをコメントアウトし、bundle exec rails erd_mapを実行する
  # mount ErdMap::Engine => "erd_map"
end