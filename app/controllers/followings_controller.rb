class FollowingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @followings = User.find(params[:account_id]).followings
  end
end
