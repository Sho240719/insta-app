require 'rails_helper'

RSpec.describe User, type: :model do
  context 'アカウントネーム、email、パスワードが入力されている場合' do
    let!(:user) { build(:user) }

    it 'アカウントを保存できる' do
      expect(user).to be_valid
    end
  end

  context 'アカウントネームがない場合' do
    let!(:user) { build(:user, account_name: '') }

    before do
      user.save
    end

    it 'アカウントを保存できない' do
      expect(user.errors.messages[:account_name][0]).to eq("can't be blank")
    end
  end

  context 'アカウントネームが同じの場合' do
    let!(:existing_user) { create(:user, account_name: 'test') }
    let!(:new_user) { build(:user, account_name: 'test') }

    before do
      new_user.save
    end

    it 'アカウントを保存できない' do
      expect(new_user.errors[:account_name]).to include('has already been taken')
    end
  end
end
