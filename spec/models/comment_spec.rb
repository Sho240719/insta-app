require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  context '内容が入力されている場合' do
    let!(:comment) { build(:comment, user: user, post: post) }

    it 'コメントを保存できる' do
      expect(comment).to be_valid
    end
  end

  context '内容が20文字を超える場合' do
    let!(:comment) { build(:comment, content: Faker::Lorem.characters(number: 30), user: user, post: post) }

    before do
      comment.save
    end

    it 'コメントを保存できない' do
      expect(comment.errors.messages[:content][0]).to eq('is too long (maximum is 20 characters)')
    end
  end
end
