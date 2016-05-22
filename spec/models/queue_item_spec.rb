require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  # it { should validate_presence_of :position }
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }

  context "When a user is creating queue items" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    subject { QueueItem.create(user: user, video: video)}

    it "sets active to true" do
      expect(subject.active).to be_true
    end

    context "when the user has no other active queue items" do
      it "sets the position to 1" do
        expect(subject.position).to eq 1
      end
    end

    context "when the user has one other active queue item" do
      before { QueueItem.create(user: user, video: video) }

      it "sets teh position to 2" do
        expect(subject.position).to eq 2
      end
    end
  end
end
