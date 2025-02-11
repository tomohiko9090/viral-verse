require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:admin) { create(:user, role: :admin) }
  # let(:multipul_owner) { create(:user, role: :owner, shop: company2) }
  let!(:multipul_owner) { create(:user, :owner) }
  let!(:owner) { create(:user, :owner) }
  # let(:normal_user) { create(:user, role: :normal) }

  let!(:shop1) { create(:shop, name: 'テスト店舗1') }
  let!(:shop2) { create(:shop, name: 'テスト店舗2') }
  let!(:shop3) { create(:shop, name: 'テスト店舗3') }

  let!(:shop_user1) { create(:shop_user, shop: shop1, user: multipul_owner) }
  let!(:shop_user2) { create(:shop_user, shop: shop2, user: multipul_owner) }
  let!(:shop_user3) { create(:shop_user, shop: shop1, user: owner) }

  describe "GET /shops" do
    context "システム管理者の場合" do
      before do
        post '/login', params: {
          email: admin.email,
          password: admin.password
        }
        get shops_path
      end

      it "全ての店舗が表示される" do
        expect(response).to have_http_status(200)
        expect(response.body).to include("テスト店舗1")
        expect(response.body).to include("テスト店舗2")
      end
    end

    context "複数店舗オーナー（複数店舗）の場合" do
      before do
        post '/login', params: {
          email: multipul_owner.email,
          password: multipul_owner.password
        }
        get shops_path
      end

      it "自社の店舗のみ表示されること" do
        expect(response).to have_http_status(200)
        expect(response.body).to include("テスト店舗1")
        expect(response.body).to include("テスト店舗2")
        expect(response.body).not_to include("テスト店舗3")
      end
    end

    context "通常オーナー（1店舗のみ）" do
      before do
        post '/login', params: {
          email: owner.email,
          password: owner.password
        }
      end

      it "店舗詳細ページにリダイレクトされること" do
        expect(response).to redirect_to(shop_path(shop1))
      end
    end
  end
end
