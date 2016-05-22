class VideosController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:search]

  def index
    @categories = Category.all
    @categories_w_videos = {}

    @categories.each do |category|
      @categories_w_videos[category.name] = category.videos.map {|video| video}
    end
  end

  def show
    @video = Video.find params[:id]
    @review = Review.new(video: @video, user: current_user)
  end

  def search
    if params[:search].present?
      @videos = Video.search_by_title params[:search]
    else
      @videos = []
    end
  end


  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover_url, :large_cover_url, :search_term)
  end
end
