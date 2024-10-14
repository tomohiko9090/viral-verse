class AddQrCodeToShops < ActiveRecord::Migration[7.1]
  def change
    add_column :shops, :qr_code, :string
  end
end
