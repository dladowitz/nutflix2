class VideosController < ApplicationController
  def index
    @videos = Video.all
  end

  def show
    @video = Video.find params[:id]
  end

  private

  def video_params
    params.require(:video).permit(:id, :title, :description, :small_cover_url, :large_cover_url)
  end
end
