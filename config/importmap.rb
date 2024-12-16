# Pin npm packages by running ./bin/importmap
# 共通のパッケージをピン留め
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"

if Rails.env.development?
  # 開発環境: 従来通りの動的なコントローラー読み込み
  pin_all_from "app/javascript/controllers", under: "controllers"
else
  # 本番環境: 明示的なコントローラーのピン留め
  pin "controllers/application", to: "controllers/application.js"
  pin "controllers/hello_controller", to: "controllers/hello_controller.js"
  pin "controllers/modal_controller", to: "controllers/modal_controller.js"
  pin "controllers/star_rating_controller", to: "controllers/star_rating_controller.js"
  pin "controllers/index", to: "controllers/index.js"
end
