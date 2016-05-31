require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }

  context "When a user is creating queue items" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    subject { QueueItem.create(user: user, video: video) }

    it "sets active to true by default" do
      expect(subject.active).to be_true
    end

    context "when the user has no other active queue items" do
      it "sets the position to 1" do
        expect(subject.position).to eq 1
      end
    end

    context "when the user has one other active queue item" do
      before { QueueItem.create(user: user, video: video) }

      it "sets the position to 2" do
        expect(subject.position).to eq 2
      end

      it "forces all items in a users queue to unique positions" do
        queue_item_2 = QueueItem.create(user: user, video: video, position: 2)
        queue_item_2.update_attributes(position: 1)
        expect(queue_item_2.reload.position).not_to eq 1
      end
    end
  end

  context "when a user is de-activating a queue_item" do
    let(:user) { Fabricate(:user) }

    context "when the user has multiple queue items" do
      let!(:queue_item_1) { Fabricate(:queue_item, user: user) }
      let!(:queue_item_2) { Fabricate(:queue_item, user: user) }
      let!(:queue_item_3) { Fabricate(:queue_item, user: user) }

      context "when deleting the first queue time" do
        subject { queue_item_1.update_attributes(active: false) }

        it "should reset the position of all other itmes correctly" do
          subject
          expect(queue_item_2.reload.position).to eq 1
          expect(queue_item_3.reload.position).to eq 2
        end
      end

      context "when deleting an item in the middle of the queue" do
        subject { queue_item_2.update_attributes(active: false) }

        it "should not reset the position of the first item" do
          subject
          expect(queue_item_1.reload.position).to eq 1
        end

        it "should reset the position of later items" do
          subject
          expect(queue_item_3.reload.position).to eq 2
        end
      end
    end
  end

end
