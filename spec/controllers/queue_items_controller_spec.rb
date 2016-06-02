require 'spec_helper'

describe QueueItemsController do
  let(:user) { Fabricate(:user) }

  describe "GET 'index'" do
    subject { get 'index', user_id: user.id }

    context "with a logged in user" do
      before { login_user user }

      context "when the user has one item in their queue" do
        let!(:queue_item_1) { Fabricate(:queue_item, user: user) }
        before { subject }

        it "returns http success" do
          expect(response).to be_success
        end

        it "returns the index template" do
          expect(response).to render_template :index
        end

        it "finds all the user's queue_items" do
          expect(assigns(:queue_items)).to eq [queue_item_1]
        end
      end

      context "when the user has multiple items in their queue" do
        let!(:queue_item_1) { Fabricate(:queue_item, user: user) }
        let!(:queue_item_2) { Fabricate(:queue_item, user: user) }

        it "finds all the user's queue_items" do
          subject
          expect(assigns(:queue_items)).to eq [queue_item_1, queue_item_2]
        end

        context "when the user as in-active queue_items" do
          before do
            queue_item_1.update_attributes(active: false)
            subject
          end

          it "does not find the inactive items" do
            expect(assigns(:queue_items)).to eq [queue_item_2]
          end
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
    let!(:queue_item_1) { Fabricate(:queue_item, user: user) }
    subject { delete 'destroy', id: queue_item_1.id, user_id: user.id }

    context "with a logged in user" do
      before { login_user user }

      it "should change the queue item to in-active" do
        expect{ subject }.to change{ queue_item_1.reload.active }.to false
      end

      context "when a user tries to deactivate someone else's queue item" do
        let!(:queue_item_2) { Fabricate(:queue_item) }
        subject { delete 'destroy', id: queue_item_2.id, user_id: user.id }

        it "should not change the status of the queue item" do
          subject
          expect(queue_item_2.reload.active).to be true
        end
      end

      context "when the user has more than one queue items" do
        let!(:queue_item_2) { Fabricate(:queue_item, user: user) }
        subject { delete 'destroy', id: queue_item_1.id, user_id: user.id }

        it "should reorder the positions of all the remaining queue items" do
          subject
          expect(queue_item_2.reload.position).to eq 1
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

  describe "POST reorder" do
    let!(:queue_item_1) { Fabricate(:queue_item, user: user) }
    let!(:queue_item_2) { Fabricate(:queue_item, user: user) }
    let!(:queue_item_3) { Fabricate(:queue_item, user: user) }
    let!(:queue_item_4) { Fabricate(:queue_item, user: user) }
    let!(:queue_item_5) { Fabricate(:queue_item, user: user) }


    context "with a logged in user" do
      before { login_user user }

      context "when a user moves an item up in the order" do
        subject { post 'reorder', user_id: user.id, queue: [{ "id" => queue_item_1.id, "new_position" => "1" }, { "id" => queue_item_2.id, "new_position" => "2" }, { "id" => queue_item_3.id, "new_position" => "3" }, { "id" => queue_item_4.id, "new_position" => "2" }, { "id" => queue_item_5.id, "new_position" => "5" }] }


        it "redirects to the index page" do
          subject
          expect(response).to redirect_to user_queue_items_path user
        end

        it "correctly sets the position of the changed item" do
          subject
          expect(queue_item_4.reload.position).to eq 2
        end

        it "leaves alone items after the chaned item" do
          subject
          expect(queue_item_5.reload.position).to eq 5
        end

        it "leaves alone anything before the insertion point of the change" do
          subject
          expect(queue_item_1.reload.position).to eq 1
        end

        it "correctly resets any item between the insertion point and the original position of the changed item" do
          subject
          expect(queue_item_2.reload.position).to eq 3
          expect(queue_item_3.reload.position).to eq 4
        end
      end

      context "when a user moves an item down in the order" do
        subject { post 'reorder', user_id: user.id, queue: [{ "id" => queue_item_1.id, "new_position" => "1" }, { "id" => queue_item_2.id, "new_position" => "4" }, { "id" => queue_item_3.id, "new_position" => "3" }, { "id" => queue_item_4.id, "new_position" => "4" }, { "id" => queue_item_5.id, "new_position" => "5" }] }

        it "correctly sets the position of the changed item" do
          subject
          expect(queue_item_2.reload.position).to eq 4
        end

        it "leaves alone items before the original changed item position" do
          subject
          expect(queue_item_1.reload.position).to eq 1
        end

        it "leaves alone anything after the insertion point of the change" do
          subject
          expect(queue_item_5.reload.position).to eq 5
        end

        it "correctly resets any item between the insertion point and the original position of the changed item" do
          subject
          expect(queue_item_3.reload.position).to eq 2
          expect(queue_item_4.reload.position).to eq 3
        end
      end

      context "when a user adds a rating to an unrated queue item" do
        subject { post 'reorder', user_id: user.id, queue: [{ "id" => queue_item_1.id, "new_position" => "1", "new_rating" => "5" }, { "id" => queue_item_2.id, "new_position" => "4", "new_rating" => "0" } ] }

        it "should create a review for the user and video" do
          subject
          expect(queue_item_1.reload.current_rating).to eq 5
        end

        it "should not create a review for other queue items" do
          subject
          expect(queue_item_2.reload.current_rating).to eq nil
        end

      end

      context "when a user adds a rating to a previously rated queue item" do
        before { queue_item_1.user.reviews.create(rating: 2, video: queue_item_1.video) }
        subject { post 'reorder', user_id: user.id, queue: [{ "id" => queue_item_1.id, "new_position" => "1", "new_rating" => "5" }, { "id" => queue_item_2.id, "new_position" => "4", "new_rating" => "0" } ] }

        it "should update the correct review" do
          subject
          expect(queue_item_1.reload.current_rating).to eq 5
        end

        it "should not create a review for other queue items" do
          subject
          expect(queue_item_2.reload.current_rating).to eq nil
        end
      end
    end
  end
end
