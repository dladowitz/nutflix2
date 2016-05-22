require 'spec_helper'

describe QueueItemsController do
  let(:user)       { Fabricate(:user) }

  describe "GET 'index'" do
    subject { get 'index', user_id: user.id }

    context "when the user has one item in their queue" do
      let!(:queue_item) { Fabricate(:queue_item, user: user) }
      before { subject }

      it "returns http success" do
        expect(response).to be_success
      end

      it "returns the index template" do
        expect(response).to render_template :index
      end

      it "finds all the user's queue_items" do
        expect(assigns(:queue_items)).to eq [queue_item]
      end
    end

    context "when the user has no items in the queue" do
      context "when other users have queue_items" do
        let!(:queue_item) { Fabricate(:queue_item) }
        before { subject }

        it "finds no queue_items" do
          expect(assigns(:queue_items)).to have(0).items
        end
      end
    end


  end

  describe "POST 'create'" do
  end

  describe "DELETE 'destroy'" do
  end
end
