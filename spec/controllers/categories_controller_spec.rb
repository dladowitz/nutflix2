require 'spec_helper'

describe CategoriesController do
  describe "GET 'show'" do
    let(:category1) { Fabricate(:category) }
    let(:category2) { Fabricate(:category) }
    let(:video1)    { Fabricate(:video, category: category1) }
    let(:video2)    { Fabricate(:video, category: category2) }
    let(:user)      { Fabricate(:user)}

    subject { get 'show', id: category1.id }

    context "with a logged in user" do
      before {
        session[:id] = user.id
        subject
      }

      it "returns http success" do
        response.should be_success
      end

      it "finds the correct category" do
        expect(assigns(:category).name).to eq category1.name
      end

      it "finds the videos in that category" do
        expect(assigns(:videos)).to eq [video1]
      end

      it "does not find vidoes in other categories" do
        expect(assigns(:videos)).not_to include video2
      end
    end

    context "with no logged in user" do
      it "redirects_to the sign_in_path" do
        subject
        expect(response).to redirect_to sign_in_path
        expect(flash[:danger]).to eq "Slow down there, you need to sign in first."
      end
    end
  end
end
