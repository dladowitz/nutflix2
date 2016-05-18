require 'spec_helper'

describe VideosController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "returns a collection of all videos in the DB" do
      get 'index'
      expect(assigns(:videos)).to eq Video.all
    end
  end
end
