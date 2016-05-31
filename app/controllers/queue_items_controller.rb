class QueueItemsController < ApplicationController
  before_action :set_user, only: [:index, :create, :reorder]
  def index
    if @user
      @queue_items = @user.active_queue_items
    else
      flash[:danger] = "Couldn't find correct user."
      redirect_to home_path
    end
  end

  def create
    video = Video.find_by_id queue_items_params[:video_id]

    if @user && video
      queue_item = @user.queue_items.build queue_items_params

      if queue_item.save
        flash[:success] = "You've added #{video.title} to your queue."
        redirect_to user_queue_items_path(@user)
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

    redirect_to user_queue_items_path(current_user)
  end

  def reorder
    params[:queue].each do |queue_item_id, form_position|
      queue_item = QueueItem.find queue_item_id
      form_position = form_position.to_i
      puts "Queue Item Video: #{queue_item.video.title} at position #{queue_item.position}"

      if queue_item.position != form_position
        items_after_insertion = @user.queue_items.where("position >= ?", form_position)

        items_after_insertion.each do |item|

          unless item == queue_item
            puts "Before Update Queue Item Video: #{item.video.title} at position #{item.position}"
            item.update_attributes(position: item.position + 1)
            puts "After Update Queue Item Video: #{item.video.title} at position #{item.position}"
          else
            puts "Before Update Queue Item Video: #{queue_item.video.title} at position #{queue_item.position}"
            queue_item.update_attributes(position: form_position)
            puts "After Update Queue Item Video: #{queue_item.video.title} at position #{queue_item.position}"

            break
          end
        end

        break
      end
    end


    redirect_to user_queue_items_path @user
  end

  private

  def queue_items_params
    params.require(:queue_item).permit(:user_id, :video_id)
  end

  def set_user
    @user = User.find_by_id params[:user_id]
  end
end
