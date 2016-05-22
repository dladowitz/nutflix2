class QueueItemsController < ApplicationController
  def index
    user = User.find_by_id params[:user_id]
    if user
      @queue_items = user.queue_items
    else
      flash[:danger] = "Couldn't find correct user."
      redirect_to home_path
    end
  end
end
