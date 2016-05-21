class StaticPagesController < ApplicationController
  skip_before_filter :verify_user
  
  def front
  end
end
