class FollowersController < ApplicationController
  before_action :authenticate_user!

  def index
    @followers = User.find(params[:account_id]).followers
  end
end
