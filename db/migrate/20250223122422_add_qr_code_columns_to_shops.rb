# db/migrate/[timestamp]_add_qr_code_columns_to_shops.rb
class AddQrCodeColumnsToShops < ActiveRecord::Migration[7.1]
  def change
    rename_column :shops, :qr_code, :qr_code_ja
    change_column :shops, :qr_code_ja, :string, comment: "日本語版QRコードの保存パス"
    add_column :shops, :qr_code_en, :string, comment: "英語版QRコードの保存パス"
  end
end