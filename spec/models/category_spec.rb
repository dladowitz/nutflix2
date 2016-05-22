require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :name}

  describe "#recent_videos" do
    let(:action) { Category.create(name: "Action") }
    let(:videos) { [] }
    subject      { action.recent_videos }

    before do
      5.times { |index| videos << Video.create(title: "Iron Man #{index}", category: action)}
    end

    # it "returns the videos in reverse chronological creation order"
    it { should start_with videos.last }
    it { should end_with videos.first }

    context "when there are 6 or less videos in the category" do
      it { should have(5).items }
    end

    context "when there are more than 6 vidoes in the category" do
      before do
        Video.create(title: "Iron Man 6", category: action)
        Video.create(title: "Iron Man 7", category: action)
      end

      it { should have(6).items }
    end
  end
end
