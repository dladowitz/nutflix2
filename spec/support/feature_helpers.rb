def sign_in_user_through_form(user)
  visit sign_in_path
  fill_in "session[email]", with: user.email
  fill_in "session[password]", with: user.password
  click_button "Sign in"

  page.should have_content "Successful signin"
end

def sign_out_through_link
  click_link "Sign Out"
end
