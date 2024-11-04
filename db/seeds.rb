puts "seedを初期化します。"

ActiveRecord::Base.transaction do
  # まず、ユーザーのshop_id参照を解除
  User.with_deleted.update_all(shop_id: nil)

  # 次に、ショップを物理削除
  Shop.with_deleted.find_each(&:really_destroy!)

  # 最後に、ユーザーを物理削除
  User.with_deleted.find_each(&:really_destroy!)
end

shops = [
  { name: "KUZUBAラーメン", url: "https://maps.app.goo.gl/uuVdbCPZxFDdPhSd8" },
  { name: "tomohiko美容室", url: "https://www.google.com/maps/search/Lily.%E3%80%90%E3%83%AA%E3%83%AA%E3%82%A3%E3%80%91%E5%8C%97%E5%8D%83%E4%BD%8F/@35.7498555,139.7999379,17z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI0MTAxNi4wIKXMDSoASAFQAw%3D%3D" },
]

created_shops = shops.map do |shop_data|
  shop = Shop.create!(shop_data)
  shop.generate_qr_code
  shop
end

admin_user = User.create_with(
  name: "管理者",
  password: "password",
  role: :admin,
  language_id: 1
).find_or_create_by!(email: "admin@example.com")

created_shops.each_with_index do |shop, index|
  User.create_with(
    name: "店長#{index + 1}",
    password: "password",
    role: :owner,
    language_id: 1,
    shop_id: shop.id
  ).find_or_create_by!(email: "owner#{index + 1}@example.com")
end

# レビューデータの生成
puts "レビューデータを生成します..."

# サンプルのコメント配列
comments = [
  "とても美味しかったです！",
  "また来たいです",
  "素晴らしい接客でした",
  "おすすめです",
  "期待以上でした",
  "満足しています",
  "良い体験でした"
]

# 過去6ヶ月分のレビューを生成
created_shops.each do |shop|
  6.downto(0) do |months_ago|
    # 各月のレビュー数をランダムに設定（5〜15件）
    review_count = rand(5..15)

    review_count.times do
      # その月のランダムな日時を生成
      date = months_ago.months.ago.beginning_of_month + rand(0..27).days + rand(10..20).hours

      Review.create!(
        shop: shop,
        score: rand(3..5),  # 3〜5の評価をランダムに設定
        comments: comments.sample,  # コメントをランダムに選択
        created_at: date,
        updated_at: date
      )
    end
  end
end

puts "#{Shop.count} shops と #{User.count} users と #{Review.count} reviews を作成しました。"
