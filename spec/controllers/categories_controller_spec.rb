require 'spec_helper'

describe CategoriesController do
  describe "GET 'show'" do
    before do
      @action = Category.create(name: "Action")
      @comedy = Category.create(name: "Comedy")
      @thor = Video.create(title: "Thor", category: @action)
      @futurama = Video.create(title: "Futurama", category: @comedy)
      @tony = User.create(email: "tony@stark_labs.com", password: "asdfasdf", password_confirmation: "asdfasdf", full_name: "Tony Stark")
    end

    subject { get 'show', id: @action.id }

    context "with a logged in user" do
      before {
        session[:id] = @tony.id
        subject
      }

      it "returns http success" do
        response.should be_success
      end

      it "finds the correct category" do
        expect(assigns(:category).name).to eq @action.name
      end

      it "finds the videos in that category" do
        expect(assigns(:videos)).to eq [@thor]
      end

      it "does not find vidoes in other categories" do
        expect(assigns(:videos)).not_to include @futurama
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
