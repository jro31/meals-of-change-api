class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  has_one_attached :photo, dependent: :destroy
  # TODO - Delete from AWS if a different photo is added, or if the recipe is destroyed
  # Not sure how, but 'purge' might help - https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/One.html#method-i-purge

  accepts_nested_attributes_for :ingredients, :steps

  validates_presence_of :name
  # TODO - Add validation that at least one ingredient must exist? (will make testing a pain)
  # TODO - Add validation that at least one step must exist? (will make testing a pain)
  # TODO - Add validation that cannot have more than 15 tags

  default_scope { order(created_at: :desc) }

  def photo_url
    if photo.attached?
      photo.blob.service_url
    end
  end
end
