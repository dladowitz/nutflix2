require 'spec_helper'

describe SessionsController do
  describe "GET 'new'" do

    context "with a valid username and password" do
      subject { get 'new', session: { email: "tony@stark_labs.com", password: "asdfasdf" } }
      before { subject }

      it "returns http success" do
        expect(response).to be_success
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET 'create'" do
    before do
       @tony = User.create(email: "tony@stark_labs.com", password: "asdfasdf", password_confirmation: "asdfasdf", full_name: "Tony Stark")
      subject
    end

    context "with a valid username and password" do
      subject { post 'create', session: { email: "tony@stark_labs.com", password: "asdfasdf" } }

      it "renders the home template" do
        expect(response).to redirect_to videos_path
      end

      it "sets the session properly" do
        expect(session[:id]).to eq @tony.id
      end
    end

    context "with a invalid username and password" do
      subject { post 'create', session: { email: "tony@stark_labs.com", password: "bad password" } }

      it "re-renders the new template" do
        expect(response).to render_template :new
      end

      it "does not set the session" do
        expect(session[:id]).to be_nil
      end
    end
  end
end
