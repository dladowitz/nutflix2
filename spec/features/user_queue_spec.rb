require "spec_helper"

feature "User adds video to queue" do
  background do
    @user  = Fabricate(:user)
    @video = Fabricate(:video)
  end

  scenario "with existing user and video" do
    visit sign_in_path
    fill_in "session[email]", with: @user.email
    fill_in "session[password]", with: @user.password
    click_button "Sign in"

    # On Videos Page
    find(:xpath, "//a[@href='/videos/#{@video.id}']").click

    # On Video Page
    page.should have_content @video.title
    click_link "+ My Queue"

    # On My Queue Page
    page.should have_content "My Queue"
    page.should have_content @video.title
    click_link @video.title

    # On Video Page
    page.should have_content @video.title
    page.should_not have_content "+ My Queue"
  end
end
