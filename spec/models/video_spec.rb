require 'spec_helper'

describe Video do
  let(:action) { Category.create(name: "Action") }
  let(:video)  { Video.create(title: "Captain America: Civil War", category: action) }
  let(:video2) { Video.create(title: "Captain America: The First Avenger", category: action) }

  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :category_id }
  it { should be_instance_of Video }

  context "with valid arguments" do
    it "has a title" do
      expect(video.title).to eq "Captain America: Civil War"
    end

    it "has a category" do
      expect(video.category.name).to eq "Action"
    end
  end

  describe "#search_by_title" do
    context "when no matching videos are in the database" do
      subject { Video.search_by_title "Black Widow" }

      # "returns an empty array"
      it { should eq [] }
    end

    context "when one matching video is in the DB" do
      subject { Video.search_by_title "Captain America: Civil War" }

      # "returns one video"
      it { should eq [video] }

      it "is case insensative" do
        expect(Video.search_by_title "captaiN aMerica: ciVil War").to eq [video]
      end
    end

    context "when one video matches a partial search term" do
      subject { Video.search_by_title "Civil War" }

      # "returns one video"
      it { should eq [video] }
    end

    context "when two matching videso are in the DB" do
      subject { Video.search_by_title "Captain"}

      # "returns both videos"
      it { should eq [video, video2] }
    end
  end
end
