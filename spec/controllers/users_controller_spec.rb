require 'spec_helper'

describe UsersController do
  describe "GET 'new'" do
    subject { get 'new' }
    before { subject }

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end

    it 'returns a user object' do
      expect(assigns(:user)).to be_instance_of User
      expect(assigns(:user)).not_to be_persisted
    end
  end

  describe "POST 'create'" do
    context "with valid params" do
      subject { post 'create', user: { full_name: "Tony Stark", email: "tony@stark_labs.com", password: "asdfasdf", password_confirmation: "asdfasdf" }}

      it "adds a new user to the DB" do
        expect{ subject }.to change { User.count }.by 1
      end

      it "renders the sign in template"
    end

    context "with invalid params" do
      subject { post 'create', user: { full_name: "Tony Stark" }}

      it "does not add a user to the DB" do
        expect{ subject }.not_to change { User.count }
      end

      it "re-renders the new user template" do
        subject
        expect(response).to render_template :new
      end
    end
  end
end
