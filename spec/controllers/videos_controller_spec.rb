require 'spec_helper'

describe VideosController do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "retuns the index template" do
      get 'index'
      expect(response).to render_template :index
    end

    it "returns a collection of all videos in the DB" do
      get 'index'
      expect(assigns(:videos)).to eq Video.all
    end
  end

  describe "GET 'Show'" do
    before {
      @video = Video.create(title: "Thor")
    }

    it "returns http succss" do
      get 'show', id: @video.id
      response.should be_success
    end

    it "returns the show template" do
      get 'show', id: @video.id
      expect(response).to render_template :show
    end

    it "returns the correct video" do
      get 'show', id: @video.id
      expect(assigns(:video)).to eq @video
    end
  end
end
