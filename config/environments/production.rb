require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 1.基本設定
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  # 2.アセットとキャッシュの設定
  config.action_controller.perform_caching = true
  config.assets.compile = true
  config.assets.js_compressor = :terser
  config.assets.css_compressor = :sass
  config.public_file_server.enabled = true
  config.serve_static_files = true

  # 3.セキュリティ関連の設定
  config.force_ssl = false
  config.ssl_options = { redirect: { status: 301 } }
  config.action_dispatch.cookies_secure = true
  config.action_dispatch.cookies_http_only = true
  config.action_dispatch.cookies_same_site = :lax
  config.action_dispatch.cookies_expire_after = 24.hours
  config.action_controller.forgery_protection_origin_check = false

  # 3.ログとデバッグの設定
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::INFO
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # # 4.セッションストアとドメイン設定を追加
  # config.session_store :cookie_store,
  #   key: '_kuchikomi_elevator_session',
  #   domain: 'viral-verse.com',
  #   secure: true,
  #   same_site: :lax

  # 5.その他の機能設定
  config.active_storage.service = :local
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end