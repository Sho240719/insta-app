require 'rails_helper'

RSpec.describe 'Api::Follows', type: :request do
  let!(:follower_user) { create(:user) } # フォローする人
  let!(:following_user) { create(:user) } # フォローされる人

  describe 'POST /api/follows' do
    before do
      sign_in follower_user
    end

    it 'フォローが保存でき、200ステータスが返ってくる' do
      expect {
        post api_follows_path(account_id: following_user.id)
      }.to change {Relationship.count}.by(1)

      expect(response).to have_http_status(200)
    end

    it 'ログインしないでフォローするとリダイレクトする' do
      sign_out follower_user
      post api_follows_path(account_id: following_user.id)
      expect(response).to have_http_status(302)
    end
  end
end
