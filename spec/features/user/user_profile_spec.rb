require 'spec_helper'
require_relative "user_helpers.rb"

feature "User views profile page" do
  background do
    @user = Fabricate(:user)
    @user2  = Fabricate(:user)
    @video1 = Fabricate(:video)
    @video2 = Fabricate(:video)
    @video3 = Fabricate(:video)
  end

  scenario "user views another user's profile" do
    sign_in_user_through_form @user
    add_video_to_queue @video1
    add_video_to_queue @video2
    add_video_to_queue @video3
  end
end
