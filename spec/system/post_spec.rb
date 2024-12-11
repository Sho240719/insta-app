require 'rails_helper'

RSpec.describe 'Post', type: :system do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, user: user) }

  it 'ポスト一覧が表示される' do
    visit root_path
    posts.each do |post|
      expect(page).to have_content(post.content)
    end
  end
end
