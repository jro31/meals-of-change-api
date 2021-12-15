class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  has_one_attached :photo

  accepts_nested_attributes_for :ingredients, :steps

  validates_presence_of :name
  # Add validation that at least one ingredient must exist? (will make testing a pain)
  # Add validation that at least one step must exist? (will make testing a pain)
  # Add validation that cannot have more than 15 tags

  def photo_url
    if photo.attached?
      photo.blob.service_url
    end
  end
end
