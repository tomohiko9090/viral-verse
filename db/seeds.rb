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

puts "#{Shop.count} shops と #{User.count} users を作成しました。"
