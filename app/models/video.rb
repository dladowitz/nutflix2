class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, :category_id, presence: true

  # Class Methods
  def self.search_by_title(search_term)
    # This is case insensative
    Video.where("lower(title) LIKE ?", "%#{search_term.downcase}%")
  end
end
