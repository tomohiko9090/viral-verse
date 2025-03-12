# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_12_144219) do
  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "レビュー情報を管理するテーブル", force: :cascade do |t|
    t.bigint "shop_id", null: false, comment: "店舗ID（shops.id）"
    t.integer "score", null: false, comment: "評価点数（1-5）"
    t.text "comments", null: false, comment: "レビューコメント（最大1000文字）"
    t.text "feedback1", comment: "アンケート回答1（評価1-3の場合）"
    t.text "feedback2", comment: "アンケート回答2（評価1-3の場合）"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.datetime "deleted_at", comment: "論理削除日時"
    t.index ["deleted_at"], name: "index_reviews_on_deleted_at"
    t.index ["shop_id"], name: "index_reviews_on_shop_id"
  end

  create_table "shop_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shop_id", null: false, comment: "店舗ID（shops.id）"
    t.bigint "user_id", null: false, comment: "ユーザーID（users.id）"
    t.datetime "deleted_at", comment: "論理削除日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_shop_users_on_deleted_at"
    t.index ["shop_id", "user_id"], name: "index_shop_users_on_shop_id_and_user_id", unique: true
    t.index ["shop_id"], name: "index_shop_users_on_shop_id"
    t.index ["user_id"], name: "index_shop_users_on_user_id"
  end

  create_table "shops", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "店舗情報を管理するテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "店舗名"
    t.string "url", comment: "google URL"
    t.string "url_tripadvisor", comment: "tripadvisor URL"
    t.string "qr_code_ja", comment: "日本語版QRコードの保存パス"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.datetime "deleted_at", comment: "論理削除日時"
    t.string "qr_code_en", comment: "英語版QRコードの保存パス"
    t.index ["deleted_at"], name: "index_shops_on_deleted_at"
    t.index ["url"], name: "index_shops_on_url", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", comment: "ユーザー情報を管理するテーブル", force: :cascade do |t|
    t.string "name", null: false, comment: "ユーザー名"
    t.string "email", null: false, comment: "メールアドレス（一意）"
    t.string "password_digest", null: false, comment: "パスワードハッシュ（6文字以上）"
    t.integer "role", default: 2, null: false, comment: "ユーザー権限（1:admin管理者, 2:owner店舗オーナー）"
    t.integer "language_id", default: 1, null: false, comment: "言語ID（1:日本語）"
    t.datetime "created_at", null: false, comment: "作成日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.datetime "deleted_at", comment: "論理削除日時"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reviews", "shops"
  add_foreign_key "shop_users", "shops"
  add_foreign_key "shop_users", "users"
end
