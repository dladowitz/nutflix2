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
      expect(subject.first.id).to eq @videos.last.id
      expect(subject.last.id).to eq @videos.first.id
    end

    context "when there are 6 or less videos in the category" do

      it "returns the exact number of videos in the category"
    end

    context "when there are more than 6 vidoes in the category" do
      it "returns only 6 videos"
    end
  end
end
