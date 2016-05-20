class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_email session_params[:email]

    if @user && @user.authenticate(session_params[:password])
      session[:id] = @user.id

      flash[:success] = "Successful signin"
      redirect_to videos_path
    else
      flash[:danger] = "Incorrect email or password"
      render :new
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
