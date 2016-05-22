require 'spec_helper'

describe ReviewsController do
  describe "POST 'create'" do
    let(:video) { Fabricate(:video) }
    let(:user)  { Fabricate(:user) }

    subject     { post 'create', review: { video: video, rating: 5, user: user, text: "This was a great movie"}}

    context "with a logged in user" do
      it { should change{ Review.count}.by 1 }

      it "redirects to the current video_path"
      it "finds the correct video"
      it "finds the correct user"
    end

    context "with no logged in user"
  end
end
