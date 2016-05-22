require 'spec_helper'

describe ReviewsController do
  describe "POST 'create'" do
    let(:video) { Fabricate(:video) }
    let(:user)  { Fabricate(:user) }

    context "with a logged in user" do
      before { login_user user }
      subject     { post 'create', review: { video_id: video, rating: 5, user_id: user, text: "This was a great movie"}}

      it { should redirect_to video_path video }

      it "adds a review to the DB" do
        expect{ subject }.to change{ Review.count }.by 1
      end

      it "finds the correct video" do
        subject
        expect(assigns(:review).video).to eq video
      end

      it "finds the correct user"  do
        subject
        expect(assigns(:review).user).to eq user
      end
    end

    context "with no logged in user" do
      subject  { post 'create', review: { video_id: video, rating: 5, user_id: user, text: "This was a great movie"}}

      it { should redirect_to sign_in_path }

      it "does not add a review to the DB" do
        expect{ subject }.not_to change{ Review.count }
      end
    end
  end
end
