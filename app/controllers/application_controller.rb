class ApplicationController < ActionController::Base
  # devise機能、新規登録時にアカウントネームも含めるように
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    # Sign up時にaccount_nameを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:account_name])
  end
end
