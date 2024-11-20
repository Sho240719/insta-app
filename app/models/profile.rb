# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.url_for(avatar) : 'default-avatar.png'
  end
end
