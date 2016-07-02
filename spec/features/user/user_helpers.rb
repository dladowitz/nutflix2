def expect_video_in_queue(video)
  page.should have_content video.title
end

def expect_link_to_not_be_present(link_text)
  page.should_not have_content link_text
end

def visit_video_page(video)
  click_link video.title
  page.should have_content video.title
end

def add_video_to_queue(video)
  visit home_path
  find("//a[href='/videos/#{video.id}']").click
  page.should have_content video.title
  click_link "+ My Queue"
end

def update_video_position(video, position)
  within(:xpath, "//tr[contains(.,'#{video.title}')]") do
    fill_in "queue[][new_position]", with: position
  end

  click_button "Update Instant Queue"
end

def expect_video_position(video, position)
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='number']").value).to eq position.to_s
end
