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
    # Add videos to queue and write reviews
    add_video_to_queue_via_db(@video1, @user)
    add_video_to_queue_via_db(@video2, @user)
    add_video_to_queue_via_db(@video3, @user)
    write_review(@video1, @user)
    write_review(@video2, @user)
    write_review(@video3, @user)

    sign_in_user_through_form(@user2)
    visit "/users/#{@user.id}"
    expect_correct_user_profile(@user)
    expect_correct_queue_items(@user)
    expect_correct_reviews(@user)
    save_and_open_page
  end

  def write_review(video, user)
    video.reviews.create(user_id: user.id, rating: 4, text: Faker::Hacker.say_something_smart)
  end

  def add_video_to_queue_via_db(video, user)
    video.queue_items.create(user_id: user.id)
  end

  def expect_correct_user_profile(user)
    page.should have_content "#{user.full_name}'s video collection"
  end

  def expect_correct_queue_items(user)
    page.should have_content "video collections (#{user.queue_items.count})"
    user.queue_items.each do |queue_item|
      #TOOD should really make this check for a TR with title and category
      page.should have_content queue_item.video.title
      page.should have_content queue_item.video.category.name
    end
  end

  def expect_correct_reviews(user)
    page.should have_content "Reviews (#{user.reviews.count})"
    user.reviews.each do |review|
      page.should have_link(review.video.title, href: video_path(review.video))
      page.should have_content "Rating: #{review.rating} / 5"
      page.should have_content review.text
    end
  end
end
