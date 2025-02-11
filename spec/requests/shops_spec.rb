require 'rails_helper'

RSpec.describe "Shops", type: :request do
  let!(:admin) { create(:user, role: :admin) }
  # let(:multipul_owner) { create(:user, role: :owner, shop: company2) }
  let!(:multipul_owner) { create(:user, :owner) }
  let!(:owner) { create(:user, :owner) }
  # let(:normal_user) { create(:user, role: :normal) }

  let!(:shop1) { create(:shop, name: 'テスト店舗1') }
  let!(:shop2) { create(:shop, name: 'テスト店舗2') }
  let!(:shop3) { create(:shop, name: 'テスト店舗3') }

  before do
    create(:shop_user, shop: shop1, user: owner)
    create(:shop_user, shop: shop1, user: multipul_owner)
    create(:shop_user, shop: shop2, user: multipul_owner)
  end

  describe "POST /shops" do
    context "システム管理者の場合" do
      before do
        post '/login', params: {
          email: admin.email,
          password: admin.password
        }
      end

      it "店舗を作成できること" do
        expect {
          post shops_path, params: {
            shop: {
              name: "新規テスト店舗",
              url: "https://example.com"
            }
          }
        }.to change(Shop, :count).by(1)
        expect(Shop.last.name).to eq("新規テスト店舗")
        expect(Shop.last.url).to eq("https://example.com")
      end
    end

    context "通常オーナーの場合" do
      before do
        post '/login', params: {
          email: owner.email,
          password: owner.password
        }
      end

      it "店舗を作成できないこと" do
        expect {
          post shops_path, params: {
            shop: {
              name: "新規テスト店舗",
              url: "https://example.com"
            }
          }
        }.not_to change(Shop, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /shops/:id" do
    context "システム管理者の場合" do
      before do
        post '/login', params: {
          email: admin.email,
          password: admin.password
        }
      end

      it "店舗を削除できること" do
        expect {
          delete shop_path(shop1)
        }.to change(Shop, :count).by(-1)

        expect(response).to redirect_to(shops_path)
        expect(Shop.exists?(shop1.id)).to be false
      end
    end

    context "通常オーナーの場合" do
      before do
        post '/login', params: {
          email: owner.email,
          password: owner.password
        }
      end

      it "店舗を削除できないこと" do
        expect {
          delete shop_path(shop1)
        }.not_to change(Shop, :count)

        expect(response).to redirect_to(root_path)
        expect(Shop.exists?(shop1.id)).to be true
      end
    end
  end
end