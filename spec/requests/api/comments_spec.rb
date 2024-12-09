require 'rails_helper'

RSpec.describe 'Api::Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comments) { create_list(:comment, 3, post: post) }

  describe 'GET /api/comments' do
    it '200ステータスが返ってくる' do
      get api_comments_path(post_id: post.id)
      expect(response).to have_http_status(200)
    end
  end
end
