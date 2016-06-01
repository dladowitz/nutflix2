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
      flash[:success] = "#{queue_item.video.title} removed from your queue." if @debug
      queue_item.update_attributes active: false
    else
      flash[:dabger] = "Sorry we coudn't find the correct video in your queue." if @debug
    end

    redirect_to user_queue_items_path(current_user)
  end

  def reorder
    reorder_queue_items

    redirect_to user_queue_items_path @user
  end

  private

  def queue_items_params
    params.require(:queue_item).permit(:user_id, :video_id)
  end

  def set_user
    @user = User.find_by_id params[:user_id]
  end

  def reorder_queue_items
    params[:queue].each do |queue_item_id, new_position|
      moved_item = find_item_with_new_position(queue_item_id, new_position)

      if moved_item
       direction = move_direction(moved_item, new_position.to_i)
       moved_item.update_attribute(:position, new_position)
       validate_or_reorder(direction, moved_item)

        break
      end
    end
  end

  def find_item_with_new_position(queue_item_id, new_position)
    queue_item = QueueItem.find queue_item_id
    new_position = new_position.to_i
    puts "Queue Item Video: #{queue_item.video.title} at position #{queue_item.position}" if @debug

    if queue_item.position != new_position
      return queue_item
    else
      nil
    end
  end

  def move_direction(moved_item, new_position)
    if new_position > moved_item.position
      direction = "down"
    else
      direction = "up"
    end
  end

  def validate_or_reorder(direction, moved_item)
    if direction == "down"
      validate_position_or_decrement(moved_item)
    else
      validate_position_or_increment(moved_item)
    end
  end

  def validate_position_or_decrement(moved_item)
    non_moved_items = @user.active_queue_items.to_a
    non_moved_items = non_moved_items.reverse  #need to start validating from the other end
    non_moved_items.delete(moved_item)

    non_moved_items.each do |item|
      unless item.valid?
        item.update_attribute(:position, item.position - 1)
      end
    end
  end

  def validate_position_or_increment(moved_item)
    non_moved_items = @user.active_queue_items.to_a
    non_moved_items.delete(moved_item)

    non_moved_items.each do |item|
      unless item.valid?
        item.update_attribute(:position, item.position + 1)
      end
    end
  end
end
