require 'rails_helper'

RSpec.describe 'Api::Unfollows', type: :request do
  let!(:follower_user) { create(:user) } # フォローする人
  let!(:following_user) { create(:user) } # フォローされる人

  describe 'POST /api/unfollows' do
    before do
      follower_user.follow!(following_user.id)
      sign_in follower_user
    end

    it 'フォローが削除でき、200ステータスが返ってくる' do
      expect {
        post api_unfollows_path(account_id: following_user.id)
      }.to change { Relationship.count }.by(-1)

      expect(response).to have_http_status(200)
    end

    it 'ログインしないでアンフォローするとリダイレクトする' do
      sign_out follower_user
      post api_unfollows_path(account_id: following_user.id)
      expect(response).to have_http_status(302)
    end
  end
end
