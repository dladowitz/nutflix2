require 'spec_helper'

describe Category do
  it { should have_many :videos }


  context "with valid arguments" do
    it "creates a valid object" do
      category = Category.create(name: "Comedy")
      expect(category).to be_valid
    end

    it "has a name" do
      category = Category.create(name: "Comedy")
      expect(category.name).to eq "Comedy"
    end
  end

  context "with invalid arguments" do
    it "does not create a valid object" do
      category = Category.create
      expect(category).not_to be_valid
    end
  end
end
