class StaticPagesController < ApplicationController
  skip_before_filter :verify_user

  def front
    redirect_to home_path if current_user
  end
end
