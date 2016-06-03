require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(full_name: "Tony Stark", email: "tony@starklabs.com", password: "asdfasdf")
  end

  scenario "with exisiting username" do
    visit sign_in_path
    fill_in "session[email]", with: "tony@starklabs.com"
    fill_in "session[password]", with: "asdfasdf"
    click_button "Sign in"

    page.should have_content "Successful signin"
  end
end
