require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }

  describe "GET 'index'" do
    subject { get 'index', user_id: user.id }

    context "with a logged in user" do
      before { login_user user }

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

    context "with no logged in user" do
      it "shoulds redirect to the sign_in_path" do
        subject
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST 'create'" do
    let(:video) { Fabricate(:video) }
    subject { post 'create', user_id: user.id, queue_item: { video_id: video.id } }

    context "with a logged in user" do
      before { login_user user }

      context "when the user has no other queue items" do
        it "should add a queue_item to the DB" do
          expect{ subject }.to change{ QueueItem.count }.by 1
        end

        it "should create a queue item with position of one" do
          subject
          expect(QueueItem.last.position).to eq 1
        end
      end

      context "when the user has one other queue_item" do
        before { Fabricate(:queue_item, user: user) }

        it "should create a queue item with position of two" do
          subject
          expect(QueueItem.last.position).to eq 2
        end
      end
    end

    context "with no logged in user" do
      it "shoulds redirect to the sign_in_path" do
        subject
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE 'destroy'" do
    let(:queue_item) { Fabricate(:queue_item, user: user) }
    subject { delete 'destroy', id: queue_item.id, user_id: user.id }

    context "with a logged in user" do
      before { login_user user }

      it "should change the queue item to in-active" do
        expect{ subject }.to change{ queue_item.reload.active }.to false
      end

      context "when a user tries to deactivate someone else's queue item" do
        let!(:queue_item_2) { Fabricate(:queue_item) }

        it "should not change the status of the queue item" do
          delete 'destroy', id: queue_item_2.id, user_id: user.id
          expect(queue_item_2.reload.active).to be true
        end
      end
    end

    context "without a logged in user" do
      it "should redirect to the sign_in_path" do
        subject
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
