class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_user

  def verify_user
    unless current_user
      flash.now[:danger] = "Slow down there, you need to sign in first."
      redirect_to sign_in_path
    end
  end

  def current_user
    @user = User.find_by_id session[:id]
  end
end
