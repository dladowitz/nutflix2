require 'spec_helper'

describe VideosController do
  let(:user)   { Fabricate(:user) }
  let!(:video) { Fabricate(:video)}
  before       { login_user user }

  describe "GET 'index'" do
    subject { get 'index' }

    it_behaves_like "requires sign in" do
      let(:action) { subject }
    end

    context "with a logged in user" do
      before { subject }

      it "returns http success" do
        response.should be_success
      end

      it "retuns the index template" do
        expect(response).to render_template :index
      end

      it "returns a collection of all categories in the DB" do
        expect(assigns(:categories)).to eq Category.all
      end

      it "returns a list with categries full of vidoes" do
        expect(assigns(:categories_w_videos)["#{video.category.name}"]).to eq [video]
      end
    end
  end

  describe "GET 'Show'" do
    subject { get 'show', id: video.id }

    it_behaves_like "requires sign in" do
      let(:action) { subject }
    end

    context "with a logged in user" do
      before { subject }

      it "returns http succss" do
        response.should be_success
      end

      it "returns the show template" do
        expect(response).to render_template :show
      end

      it "returns the correct video" do
        expect(assigns(:video)).to eq video
      end

      it "creates new review" do
        expect(assigns(:review)).to be_instance_of Review
      end

      it "has a correcty associated review" do
        expect(assigns(:review).video).to eq video
        expect(assigns(:review).user).to eq user
      end
    end
  end

  describe "GET 'Search'" do
    let!(:video2) { Fabricate(:video, title: video.title + ": 2") }

    it_behaves_like "requires sign in" do
      let(:action) { get 'search', search: video.title }
    end

    context "with a logged in user" do
      it "returns http succss" do
        get 'search', search: video.title
        response.should be_success
      end

      it "returns the show template" do
        get 'search', search: video.title
        response.should render_template :search
      end

      context "without a search term" do
        it "returns no results" do
          get 'search', search: ""
          assigns(:videos).should be_empty
        end
      end

      context "with a search matching one video in the DB" do
        it "returns one video" do
          get 'search', search: video2.title
          expect(assigns(:videos)).to eq [video2]
        end
      end

      context "with a search matching no videos in the DB" do
        it "returns no results" do
          get 'search', search: "Black Widow"
          expect(assigns(:videos)).to be_empty
        end
      end

      context "with a search matching two videos in the DB" do
        it "returns two results" do
          get 'search', search: video.title
          expect(assigns(:videos)).to have(2).items
        end
      end
    end
  end
end
