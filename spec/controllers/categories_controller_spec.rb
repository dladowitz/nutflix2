require 'spec_helper'

describe CategoriesController do

  describe "GET 'show'" do
    before do
      @action = Category.create(name: "Action")
      @comedy = Category.create(name: "Comedy")
      @thor = Video.create(title: "Thor", category: @action)
      @futurama = Video.create(title: "Futurama", category: @comedy)
      get 'show', category: { id: @action.id }
    end

    it "returns http success" do
      response.should be_success
    end

    it "finds the correct category" do
      expect(assigns(:category).name).to eq @action.name
    end

    it "finds the videos in that category" do
      expect(assigns(:videos)).to eq [@thor]
    end

    it "does not find vidoes in other categories" do
      expect(assigns(:videos)).not_to include @futurama
    end
  end
end
