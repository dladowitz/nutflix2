require 'spec_helper'

describe Video do
  let(:iron_man) { videos(:iron_man) }


  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :category_id }

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

  describe "#search_by_title" do
    context "when no matching videos are in the database" do
      subject { Video.search_by_title "Black Widow" }

      it "returns an empty array" do
        expect(subject).to eq []
      end
    end

    context "when one matching video is in the DB" do
      it "returns one video"
    end

    context "when two matching videso are in the DB" do
      it "returns both videos"
    end
  end
end
