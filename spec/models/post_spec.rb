require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) do
    User.create!({
      account_name: Faker::Name.name,
      email: 'test@example.com',
      password: 'password'
    })
  end

  context '内容が入力されている場合' do
    let!(:post) do
      user.posts.build({
        content: Faker::Lorem.characters(number: 20)
      })
    end

    it 'ポストを保存できる' do
      expect(post).to be_valid
    end
  end

  context '内容が一文字の場合' do
    let!(:post) do
      user.posts.create({
        content: Faker::Lorem.characters(number: 1)
      })
    end

    it 'ポストを保存できない' do
      expect(post.errors.messages[:content][0]).to eq('is too short (minimum is 2 characters)')
    end
  end
end
