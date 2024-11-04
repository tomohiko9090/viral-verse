ActiveRecord::Schema[7.1].define(version: 2024_10_18_180447) do
  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.integer "score"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_reviews_on_deleted_at"
    t.index ["shop_id"], name: "index_reviews_on_shop_id"
  end

  create_table "shops", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "qr_code"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_shops_on_deleted_at"
    t.index ["url"], name: "index_shops_on_url"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 2, null: false
    t.integer "language_id", default: 1, null: false
    t.integer "shop_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "reviews", "shops"
end
