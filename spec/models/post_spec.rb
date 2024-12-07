require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }

  context '内容が入力されている場合' do
    let!(:post) { build(:post, user: user) }

    it 'ポストを保存できる' do
      expect(post).to be_valid
    end
  end

  context '内容が一文字の場合' do
    let!(:post) { build(:post, content: Faker::Lorem.characters(number: 1), user: user) }

    before do
      post.save
    end

    it 'ポストを保存できない' do
      expect(post.errors.messages[:content][0]).to eq('is too short (minimum is 2 characters)')
    end
  end
end
