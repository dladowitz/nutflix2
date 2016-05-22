require 'spec_helper'

describe Video do
  let(:video1) { Fabricate(:video) }


  it { should belong_to :category }
  it { should have_many :reviews }
  it { should validate_presence_of :title }
  it { should validate_presence_of :category_id }
  it { should be_instance_of Video }

  describe "#search_by_title" do
    context "when no matching videos are in the database" do
      subject { Video.search_by_title "Black Widow" }

      # "returns an empty array"
      it { should eq [] }
    end

    context "when one matching video is in the DB" do
      subject { Video.search_by_title video1.title }

      # "returns one video"
      it { should eq [video1] }

      it "is case insensative" do
        expect(Video.search_by_title video1.title.upcase).to eq [video1]
      end
    end

    context "when one video matches a partial search term" do
      subject { Video.search_by_title video1.title.last(5) }

      # "returns one video"
      it { should eq [video1] }
    end

    context "when two matching videso are in the DB" do
      let!(:video2) { Fabricate(:video, title: video1.title + ": 2") }
      subject { Video.search_by_title video1.title.first(5)}

      # "returns both videos"
      it { should eq [video1, video2] }
    end
  end
end
