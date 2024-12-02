class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def show
    @posts = current_user.posts
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      render json: { message: "Profile image updated successfully" }, status: :ok
    else
      render json: { error: "Failed to update profile image" }, status: :unprocessable_entity
    end
  end

  private
  def set_profile
    @profile = current_user.profile || current_user.build_profile
  end

  def profile_params
    params.require(:profile).permit(:avatar)
  end
end
