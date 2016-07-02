require 'spec_helper'

feature "User views profile page" do
  background do
    @user = Fabricate(:user)
    @user2 = Fabricate(:user)
    @video1 = Fabricate(:video)
  end

  scenario "user views another user's profile" do
    sign_in_user_through_form @user
    visit_video_page @video
  end

  #TODO move to helper as it's used more than once
  def visit_video_page(video)
    click_link video.title
    page.should have_content video.title
  end
end
