require 'rails_helper'

RSpec.describe 'Api::Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:test_post) { create(:post, user: user) }
  let!(:comments) { create_list(:comment, 3, user: user, post: test_post) }

  describe 'GET /api/comments' do
    before do
      sign_in user
    end

    it '200ステータスが返ってくる' do
      get api_comments_path(post_id: test_post.id), as: :json

      expect(response).to have_http_status(200)
      body = JSON.parse(response.body)

      expect(body.length).to eq 3
      expect(body[0]['content']).to eq(comments.first.content)
      expect(body[1]['content']).to eq(comments.second.content)
      expect(body[2]['content']).to eq(comments.third.content)
    end

    it 'コメントの作成順に上から表示する' do
      older_comment = create(:comment, user: user, post: test_post, created_at: 1.day.ago)
      new_comment = create(:comment, user: user, post: test_post, created_at: Time.current)

      get api_comments_path(post_id: test_post.id), as: :json
      body = JSON.parse(response.body)

      expect(body.fourth['id']).to eq(older_comment.id)
      expect(body.last['id']).to eq(new_comment.id)
    end
  end

  describe 'POST /api/comments' do
    context 'ログインしているばあい' do
      before do
        sign_in user
      end

      it 'コメントが保存できる' do
        comment_params = attributes_for(:comment)
        post api_comments_path(post_id: test_post.id), params: { comment: comment_params }
        expect(response).to have_http_status(200)
        expect(Comment.last['content']).to eq(comment_params[:content])
      end
    end
  end
end
