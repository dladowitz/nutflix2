require 'spec_helper'

describe StaticPagesController do

  describe "GET 'front'" do
    it "returns http success" do
      get 'front'
      response.should be_success
    end

    it "renders the front template" do
      get 'front'
      expect(response).to render_template :front
    end
  end

end
