require 'spec_helper'

describe SessionsController do
  before do
    @tony = User.create(email: "tony@stark_labs.com", password: "asdfasdf", password_confirmation: "asdfasdf", full_name: "Tony Stark")
  end

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
    before { subject }

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

  describe "DELETE 'destroy'" do
    subject { delete 'destroy' }

    context "when a user is signed in" do
      before do
        session[:id] = @tony.id
        subject
      end

      it "sets the session[:id] to nil" do
        expect(session[:id]).to be_nil
      end

      it "renders the sign_in template" do
        expect(response).to render_template :new
      end
    end

    context "when a user is not signed in" do
      before { subject }

      it "renders the sign_in template" do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
