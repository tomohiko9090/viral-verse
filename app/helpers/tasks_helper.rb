# app/helpers/tasks_helper.rb
module TasksHelper
  # タスクに関連するSQLファイルを取得する
  def get_task_sql_files(task_name)
    result = { before: nil, after: nil }
    
    # タスク名からファイル名を生成 (users:make_admin_user → make_admin_user)
    task_basename = task_name.split(':').last
    
    # SQLファイルのパス
    sql_dir = Rails.root.join('lib', 'tasks', 'sql')
    
    # SQLディレクトリが存在しない場合は作成
    FileUtils.mkdir_p(sql_dir) unless Dir.exist?(sql_dir)
    
    # before SQLファイルのパスを検索
    before_path = sql_dir.join("#{task_basename}_before.sql")
    if File.exist?(before_path)
      result[:before] = {
        filename: "#{task_basename}_before.sql",
        content: File.read(before_path)
      }
    end
    
    # after SQLファイルのパスを検索
    after_path = sql_dir.join("#{task_basename}_after.sql")
    if File.exist?(after_path)
      result[:after] = {
        filename: "#{task_basename}_after.sql",
        content: File.read(after_path)
      }
    end
    
    result
  end
  
  # SQLファイルを実行する
  def execute_sql(sql_content)
    return nil if sql_content.blank?
    
    begin
      # 結果をキャプチャして整形する
      result = capture_stdout do
        result_value = eval(sql_content)
        # evalの結果も表示する（通常の出力に加えて）
        puts "\n=> #{result_value.inspect}" unless result_value.nil?
      end
      
      # 空文字列の場合はnilを返す
      return result.present? ? result.strip : "実行完了（出力なし）"
    rescue => e
      return "Error: #{e.message}"
    end
  end
  
  private
  
  # 標準出力をキャプチャするヘルパーメソッド
  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end