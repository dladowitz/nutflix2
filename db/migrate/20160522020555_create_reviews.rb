class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.references :video, index: true
      t.integer :rating
      t.text :text

      t.timestamps
    end
  end
end
