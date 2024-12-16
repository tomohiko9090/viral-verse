app_path = File.expand_path('../../', __FILE__)

# アプリケーションサーバの性能を決定する
worker_processes 1

# アプリケーションの設置されているディレクトリを指定
working_directory app_path

# Unicornの起動に必要なファイルの設置場所を指定
pid "#{app_path}/tmp/pids/unicorn.pid"

# ポート番号を指定
listen "#{app_path}/tmp/sockets/unicorn.sock"

# ログファイルの設定
if ENV['RAILS_ENV'] == 'production'
  # 本番環境では全てのログを production.log に出力
  stderr_path "#{app_path}/log/production.log"
  stdout_path "#{app_path}/log/production.log"
else
  # 開発環境では個別のログファイルに出力
  stderr_path "#{app_path}/log/unicorn.stderr.log"
  stdout_path "#{app_path}/log/unicorn.stdout.log"
end

# バッファリングを無効化（即時ログ出力）
$stdout.sync = true
$stderr.sync = true

# Railsアプリケーションの応答を待つ上限時間を設定
timeout 60

# プリロードの設定
preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
  Rails.application.config.action_dispatch.use_cookies_with_metadata = false
end
