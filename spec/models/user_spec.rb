require 'spec_helper'

describe User do
  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password}
  it { should validate_uniqueness_of :email }
  it { should have_many :reviews }
  it { should have_many :queue_items }

  describe "#active_queue_items" do
    let(:user)    { Fabricate(:user) }
    let(:video_1) { Fabricate(:video) }
    let(:video_2) { Fabricate(:video) }
    let(:queue_item_1) { Fabricate(:queue_item, user: user, video: video_1) }
    let(:queue_item_2) { Fabricate(:queue_item, user: user, video: video_2) }

    subject { user.active_queue_items }

    context "when the user as inactive queue items" do
      before { queue_item_1.update_attributes(active: false) }

      it { should eq [queue_item_2] }
    end

    context "when the user has no inactive queue items" do

      it { should eq [queue_item_1, queue_item_2] }
    end
  end
end
