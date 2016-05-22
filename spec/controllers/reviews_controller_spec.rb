require 'spec_helper'

describe ReviewsController do
  describe "POST 'create'" do
    let(:video) { Fabricate(:video) }
    let(:user)  { Fabricate(:user) }

    context "with a logged in user" do
      before {
        # session[:id] = user.id
        login_user user
      }
      # it { should change{ Review.count}.by 1 }
      subject     { post 'create', review: { video: video, rating: 5, user: user, text: "This was a great movie"}}

      it "adds a review to the DB" do
        expect{ subject }.to change{ Review.count }.by 1

      end

      it "redirects to the current video_path"
      it "finds the correct video"
      it "finds the correct user"
    end

    context "with no logged in user" do
    end
  end
end
