module ApplicationHelper
  def current_user
    @user = User.find_by_id session[:id]
  end

  def verify_user
    unless current_user
      flash.now[:danger] = "Slow down there, you need to sign in first."
      redirect_to sign_in_path
    end
  end
end
