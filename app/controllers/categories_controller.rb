class CategoriesController < ApplicationController
  def show
    @category = Category.find category_params[:id]
    @videos = @category.videos
  end

  private

  def category_params
    params.require(:category).permit(:id, :name)
  end
end
