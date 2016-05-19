class VideosController < ApplicationController
  def index
    @categories = Category.all
    @categories_w_videos = {}

    @categories.each do |category|
      @categories_w_videos[category.name] = category.videos.map {|video| video}
    end
  end

  def show
    @video = Video.find params[:id]
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end
end
