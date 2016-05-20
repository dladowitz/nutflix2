class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = "Hi Five! User account created."
       redirect_to :root
    else
      flash[:danger] = "Whoooa tiger. Something has gone wrong."
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end
end
