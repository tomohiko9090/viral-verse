# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :load_rake_tasks
  include TasksHelper

  def index
    # タスク一覧ページを表示するアクション
  end

  def show
    @task_namespace = params[:namespace]
    @task_name = params[:name]
    @full_task_name = "#{@task_namespace}:#{@task_name}"
    
    # タスクの詳細情報を取得
    @task_info = @rake_tasks.find { |t| t[:full_name] == @full_task_name }
    
    # タスクが見つからない場合はリダイレクト
    redirect_to tasks_path, error: "タスクが見つかりませんでした" unless @task_info
  end

  def execute
    task_name = params[:task_name]
    
    if task_name.present?
      begin
        # 引数を取得して配列に変換
        args = []
        if params[:args].present?
          params[:args].each do |key, value|
            args << value if value.present?
          end
        end
        
        # 実行結果を保存する変数
        execution_results = []
        
        # 実行前のSQLを実行（存在する場合）
        if params[:before_sql_content].present?
          before_result = execute_sql(params[:before_sql_content])
          execution_results << "=== 実行前SQL結果 ==="
          execution_results << before_result if before_result.present?
        end
        
        # タスクを実行し、結果をキャプチャ
        task_result = capture_task_output do
          # 引数がある場合とない場合で処理を分ける
          if args.any?
            # 引数ありでタスクを実行
            Rake::Task[task_name].invoke(*args)
          else
            # 引数なしでタスクを実行
            Rake::Task[task_name].invoke
          end
        end
        
        execution_results << "=== タスク実行結果 ==="
        execution_results << task_result if task_result.present?
        
        # 実行後のSQLを実行（存在する場合）
        if params[:after_sql_content].present?
          after_result = execute_sql(params[:after_sql_content])
          execution_results << "=== 実行後SQL結果 ==="
          execution_results << after_result if after_result.present?
        end
        
        flash[:success] = "タスク '#{task_name}' が正常に実行されました。"
        flash[:task_result] = execution_results.join("\n")
      rescue StandardError => e
        flash[:error] = "タスク実行エラー: #{e.message}"
      ensure
        # タスクを再度実行できるように初期化
        Rake::Task[task_name].reenable if Rake::Task.task_defined?(task_name)
      end
    else
      flash[:error] = "タスク名が指定されていません。"
    end
    
    # 詳細ページに戻る場合
    if params[:namespace].present? && params[:name].present?
      redirect_to task_path(namespace: params[:namespace], name: params[:name])
    else
      redirect_to tasks_path
    end
  end
  
  # SQLクエリを個別に実行するアクション
  def execute_sql_query
    # CSRF保護を一時的に無効化（AJAXリクエスト用）
    skip_before_action :verify_authenticity_token, only: [:execute_sql_query]
    
    # 通常のフォームパラメータまたはJSONリクエストをサポート
    if params[:sql_content].present?
      sql_content = params[:sql_content]
    elsif request.content_type == 'application/json'
      # JSON形式のリクエストからsql_contentを取得
      json_params = JSON.parse(request.body.read) rescue {}
      sql_content = json_params['sql_content']
    end
    
    if sql_content.present?
      begin
        result = execute_sql(sql_content)
        render json: { success: true, result: result }
      rescue => e
        render json: { success: false, error: e.message }
      end
    else
      render json: { success: false, error: "SQLクエリが指定されていません。" }
    end
  end

  private

  def load_rake_tasks
    # すべてのRakeタスクを取得して整形
    @rake_tasks = []
    
    Rake::Task.tasks.each do |task|
      # システムタスクを除外
      next if task.name.start_with?("app:", "rails:", "yarn:", "webpacker:", "assets:", "tmp:", "db:", "log:", "restart:", "secret", "middleware", "about", "stats", "time:", "zeitwerk:", "active_record:")
      
      # ネームスペースとタスク名を分離
      if task.name.include?(":")
        namespace, name = task.name.split(":", 2)
        
        # タスクの引数情報を取得
        arg_names = task.arg_names
        
        # タスクの説明文を取得
        comment = task.comment.presence || "説明なし"
        
        @rake_tasks << {
          namespace: namespace,
          name: name,
          full_name: task.name,
          description: comment,
          arguments: arg_names
        }
      end
    end
    
    # ネームスペースごとにグループ化
    @task_groups = @rake_tasks.group_by { |t| t[:namespace] }
  end

  # タスク実行の出力をキャプチャするメソッド
  def capture_task_output
    original_stdout = $stdout
    output = StringIO.new
    $stdout = output
    
    begin
      yield
      return output.string
    ensure
      $stdout = original_stdout
    end
  end
end