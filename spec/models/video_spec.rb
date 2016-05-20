require 'spec_helper'

describe Video do
  before :each do
    action = Category.create(name: "Action")
    @video = Video.create(title: "Captain America: Civil War", category: action)
    @video2 = Video.create(title: "Captain America: The First Avenger", category: action)
  end

  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :category_id }

  context "with valid arguments" do

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
      subject { Video.search_by_title "Captain America: Civil War" }

      it "returns one video" do
        expect(subject).to eq [@video]
      end

      it "is case insensative" do
        expect(Video.search_by_title "captaiN aMerica: ciVil War").to eq [@video]
      end
    end

    context "when one video matches a partial search term" do
      subject { Video.search_by_title "Civil War" }
      it "returns one video" do
        expect(subject).to eq [@video]
      end
    end

    context "when two matching videso are in the DB" do
      subject { Video.search_by_title "Captain"}
      it "returns both videos" do
        expect(subject).to eq [@video, @video2]
      end
    end
  end
end
