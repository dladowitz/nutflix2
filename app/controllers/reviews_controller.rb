class ReviewsController < ApplicationController
  def create
    video = Video.find_by_id review_params[:video_id]
    user  = User.find_by_id review_params[:user_id]

    if video && user
      @review = Review.new review_params

      if @review.save
        flash[:success] = "You're review has been recorded."
      else
        flash[:danger] = "Something went wrong. Review not saved."
      end
    else
      flash[:danger] = "Something went wrong. Couldn't find video or user."
    end

    redirect_to video_path video
  end

  private

  def review_params
    params.require(:review).permit(:rating, :text, :user_id, :video_id)
  end
end
