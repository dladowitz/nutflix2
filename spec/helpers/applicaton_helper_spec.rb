require 'spec_helper'

describe ApplicationHelper do
  before do
    @tony = User.create(email: "tony@stark_labs.com", password: "asdfasdf", password_confirmation: "asdfasdf", full_name: "Tony Stark")
  end

  describe "#current_user" do
    context "when a user is logged in" do
      before { session[:id] = @tony.id }

      it "returns the correct user" do
        expect(current_user).to eq @tony
      end
    end

    context "when no user is logged in" do
      it "returns nil" do
        expect(current_user).to eq nil
      end
    end
  end
end
