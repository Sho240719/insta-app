require 'rails_helper'

RSpec.describe 'Api::Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comments) { create_list(:comment, 3, user: user, post: post) }

  describe 'GET /api/comments' do
    before do
      sign_in user
    end

    it '200ステータスが返ってくる' do
      headers = { 'ACCEPT' => 'application/json' }
      get api_comments_path(post_id: post.id), headers: headers

      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)
      expect(body.length).to eq 3
      expect(body[0]['content']).to eq(comments.first.content)
      expect(body[1]['content']).to eq(comments.second.content)
      expect(body[2]['content']).to eq(comments.third.content)
    end
  end
end
