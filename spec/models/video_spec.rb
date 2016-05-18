require 'spec_helper'

describe Video do
  context "with valid arguments" do
    before :each do
      action = Category.create(name: "Action")
      @video = Video.create(title: "Captain America: Civil War", category: action)
    end

    it "creates an instance of a video" do

      expect(@video).to be_instance_of Video
    end

    it "has a title" do
      expect(@video.title).to eq "Captain America: Civil War"
    end

    it "has a category" do
      expect(@video.category.name).to eq "Action"
    end
  end
end
