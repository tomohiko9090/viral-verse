# shopを指定すると、qr_codeの画像とqrのパスを削除できるスクリプト
# ex. rake "qr_code:delete[18]"
namespace :qr_code do
  desc "特定のショップのQRコードファイルを削除し、QRコードフィールドをnullに設定する"
  task :delete, [:shop_id] => :environment do |t, args|
    if args[:shop_id].blank?
      puts "Usage: rake qr_code:delete[shop_id]"
      puts "Example: rake qr_code:delete[3]"
      exit
    end

    shop_id = args[:shop_id].to_i
    shop = Shop.find_by(id: shop_id)

    if shop.nil?
      puts "ショップID #{shop_id} が見つかりません。"
      exit
    end

    puts "ショップ: #{shop.name} (ID: #{shop.id}) のQRコードを削除します。"

    # QRコードファイルを削除
    qr_files_to_delete = []

    # 日本語版QRコード
    if shop.qr_code_ja.present?
      file_path = Rails.root.join('public', shop.qr_code_ja.delete_prefix('/'))
      qr_files_to_delete << file_path if File.exist?(file_path)
    end

    # 英語版QRコード
    if shop.qr_code_en.present?
      file_path = Rails.root.join('public', shop.qr_code_en.delete_prefix('/'))
      qr_files_to_delete << file_path if File.exist?(file_path)
    end

    # ファイルの削除を実行
    deleted_files = []
    qr_files_to_delete.uniq.each do |file_path|
      if File.exist?(file_path)
        begin
          File.delete(file_path)
          deleted_files << File.basename(file_path)
          puts "ファイル削除: #{file_path}"
        rescue => e
          puts "ファイル削除エラー: #{file_path} - #{e.message}"
        end
      end
    end

    # QRコードフィールドをnullに設定
    shop.update_columns(qr_code_ja: nil, qr_code_en: nil)
    puts "ショップID #{shop_id} のQRコードフィールドをnullに設定しました。"

    # 結果の出力
    if deleted_files.any?
      puts "削除されたファイル: #{deleted_files.join(', ')}"
    else
      puts "削除対象のファイルは見つかりませんでした。"
    end

    puts "完了しました。"
  end
end