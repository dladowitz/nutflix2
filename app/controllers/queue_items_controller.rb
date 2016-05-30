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

  def create
    user = User.find_by_id params[:user_id]
    video = Video.find_by_id queue_items_params[:video_id]

    if user && video
      queue_item = user.queue_items.build queue_items_params

      if queue_item.save
        flash[:success] = "You've added #{video.title} to your queue."
        redirect_to user_queue_items_path(user)
      else
        flash[:danger] = "Something has gone all wrong and we couldn't add the video to your queue."
      end
    else
      flash[danger] = "User or video information is missing."
      redirect_to home_path
    end
  end

  def destroy
    queue_item = QueueItem.find_by_id params[:id]

    if queue_item && queue_item.user == current_user
      flash[:success] = "#{queue_item.video.title} removed from your queue."
      queue_item.update_attributes active: false
    else
      flash[:dabger] = "Sorry we coudn't find the correct video in your queue."
    end

    render :index
  end

  private

  def queue_items_params
    params.require(:queue_item).permit(:user_id, :video_id)
  end
end
