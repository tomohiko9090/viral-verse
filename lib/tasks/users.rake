namespace :users do
  desc "管理者ユーザーを作成する"
  task :make_admin_user, [:name, :email, :password, :language_id] => :environment do |t, args|
    # 引数の検証
    if args[:name].blank? || args[:email].blank? || args[:password].blank?
      puts "エラー: 名前、メールアドレス、パスワードは必須です。"
      puts "使用方法: rake users:make_admin_user[管理者,admin@example.com,password123,1]"
      next # タスクを終了
    end
    
    begin
      # ユーザーが既に存在するか確認
      if User.exists?(email: args[:email])
        puts "エラー: メールアドレス '#{args[:email]}' は既に使用されています。"
        next
      end
      
      # 言語IDのデフォルト値を設定
      language_id = args[:language_id].present? ? args[:language_id].to_i : 1
      
      # 管理者ユーザーを作成 (role=1 で固定)
      user = User.new(
        name: args[:name],
        email: args[:email],
        password: args[:password],
        password_confirmation: args[:password],
        role: 1, # 管理者ロールを固定
        language_id: language_id
      )
      
      if user.save
        puts "成功: 管理者ユーザー '#{args[:name]}' (#{args[:email]}) を作成しました。"
        puts "ロール: 管理者 (1), 言語ID: #{language_id}"
      else
        puts "エラー: ユーザーの作成に失敗しました。"
        puts user.errors.full_messages.join(", ")
      end
    rescue => e
      puts "エラー: #{e.message}"
    end
  end
end