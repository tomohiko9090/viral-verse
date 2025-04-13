# lib/tasks/setup_sql_directory.rake
namespace :setup do
  desc "Create SQL directory structure for rake tasks"
  task :sql_directory => :environment do
    # SQLファイル用のディレクトリを作成
    sql_dir = Rails.root.join('lib', 'tasks', 'sql')
    
    unless Dir.exist?(sql_dir)
      FileUtils.mkdir_p(sql_dir)
      puts "Created SQL directory at #{sql_dir}"
    end
    
    # サンプルSQLファイルを作成
    make_admin_before = sql_dir.join('make_admin_user_before.sql')
    make_admin_after = sql_dir.join('make_admin_user_after.sql')
    
    # 既存のサンプルSQLファイルがない場合は作成
    unless File.exist?(make_admin_before)
      File.write(make_admin_before, "User.all.count")
      puts "Created sample SQL file: #{make_admin_before}"
    end
    
    unless File.exist?(make_admin_after)
      File.write(make_admin_after, "User.all.count")
      puts "Created sample SQL file: #{make_admin_after}"
    end
    
    puts "SQL directory setup completed successfully."
  end
end