require 'rails_helper'

RSpec.describe "Api::Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:test_post) { create(:post, user: user) }
  let!(:like) { create(:like) }

  describe "GET /api/likes" do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it '200ステータスが返ってくる' do
        get api_like_path(post_id: test_post.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it '302ステータスが返ってくる(リダイレクトされる)' do
        get api_like_path(post_id: test_post.id)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "POST /api/likes" do
    before do
      sign_in user
    end

    it 'いいねが保存でき、200ステータスが返ってくる' do
      expect {
        post api_like_path(post_id: test_post.id)
      }.to change{ Like.count }.by(1)

      expect(response).to have_http_status(200)
    end
  end
end
