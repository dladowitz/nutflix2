class ReviewsController < ApplicationController
  def create
    binding.pry
    video = Video.find_by_id review_params[:video]
    user  = User.find_by_id review_params[:user]

    @review = Review.create(video: video, user: user)
  end
end
