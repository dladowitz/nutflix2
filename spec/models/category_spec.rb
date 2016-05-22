require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :name}

  describe "#recent_videos" do
    let(:category) { Fabricate(:category) }
    let(:videos) { [] }
    subject      { category.recent_videos }

    before do
      5.times { |index| videos << Fabricate(:video, category: category) }
    end

    # it "returns the videos in reverse chronological creation order"
    it { should start_with videos.last }
    it { should end_with videos.first }

    context "when there are 6 or less videos in the category" do
      it { should have(5).items }
    end

    context "when there are more than 6 vidoes in the category" do
      before do
        Fabricate(:video, category: category)
        Fabricate(:video, category: category)
      end

      it { should have(6).items }
    end
  end
end
