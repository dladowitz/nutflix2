class CategoriesController < ApplicationController
  def show
    @category = Category.find params[:id]
    @videos = @category.videos
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
