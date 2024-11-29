class AccountsController < ApplicationController
  def show
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to profile_path
    end

    follow_status = current_user&.has_followed?(@user)

    respond_to do |format|
      format.html
      format.json { render json: { hasFollowed: follow_status } }
    end
  end
end
