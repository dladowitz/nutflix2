class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

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

  def destroy
    if session[:id]
      session[:id] = nil
      flash.now[:success] = "Bye Bye. Have fun storming the castle."
    else
      flash.now[:danger] = "Errr, you can't log out when you aren't logged in. That's science."
    end

    render :new
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

end
