require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_presence_of :name}


  context "with valid arguments" do
    it "creates a valid object" do
      category = Category.create(name: "Comedy")
      expect(category).to be_valid
    end

    it "has a name" do
      category = Category.create(name: "Comedy")
      expect(category.name).to eq "Comedy"
    end
  end

  context "with invalid arguments" do
    it "does not create a valid object" do
      category = Category.create
      expect(category).not_to be_valid
    end
  end

  describe "#recent_videos" do
    before do
      @action = Category.create(name: "Action")
      @videos = []
      5.times { |index| @videos << Video.create(title: "Iron Man #{index}", category: @action)}
    end

    subject { @action.recent_videos }

    it "retunrs the videos in reverse chronological creation order" do
      expect(subject).to start_with @videos.last
      expect(subject).to end_with @videos.first
    end

    context "when there are 6 or less videos in the category" do

      it "returns the exact number of videos in the category" do
        expect(subject).to have(5).items
      end
    end

    context "when there are more than 6 vidoes in the category" do
      before do
        Video.create(title: "Iron Man 6", category: @action)
        Video.create(title: "Iron Man 7", category: @action)
      end

      it "returns only 6 videos" do
        expect(subject).to have(6).items
      end
    end
  end
end
