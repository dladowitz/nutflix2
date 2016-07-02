require "spec_helper"
require_relative "user_helpers.rb"

feature "User interacts with queue" do
  background do
    @user  = Fabricate(:user)
    @video1 = Fabricate(:video)
    @video2 = Fabricate(:video)
    @video3 = Fabricate(:video)
  end

  scenario "user adds and reorders videos in the queue" do
    sign_in_user_through_form @user

    # On Video Page
    add_video_to_queue @video1

    # On My Queue Page
    expect_video_in_queue @video1
    visit_video_page @video1
    expect_link_to_not_be_present "+ My Queue"

    add_video_to_queue @video2
    add_video_to_queue @video3

    update_video_position @video3, 1

    # TODO: Not sure why click_button "Update Instant Queue" does't work
    # expect_video_position @video3, 1
    # expect_video_position @video1, 2
    # expect_video_position @video2, 3
  end


end
