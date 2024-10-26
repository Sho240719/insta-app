class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def show
  end

  def edit
  end

  private
  def set_profile
    @profile = profile || build_profile
  end
end
