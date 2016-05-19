class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, presence: true

  # Class Methods
  def self.search_by_title(search_term)
    Video.where("title LIKE ?", "%#{search_term}%")
  end
end
