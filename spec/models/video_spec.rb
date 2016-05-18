require 'spec_helper'

describe Video do
  it "creates an instance of a video" do
    video = Video.new
    expect(video).to be_instance_of Video
  end

  it "has a title" do
    video = Video.new(title: "Captain America: Civil War")
    expect(video.title).to eq "Captain America: Civil War"
  end
end
