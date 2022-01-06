class Recipe < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  has_one_attached :small_photo, dependent: :destroy
  has_one_attached :large_photo, dependent: :destroy
  # TODO - Delete from AWS if a different photo is added, or if the recipe is destroyed
  # Not sure how, but 'purge' might help - https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/One.html#method-i-purge

  accepts_nested_attributes_for :ingredients, :steps

  validates_presence_of :name
  # TODO - Add validation that at least one ingredient must exist? (will make testing a pain)
  # TODO - Add validation that at least one step must exist? (will make testing a pain)
  # TODO - Add validation that cannot have more than 9 tags
  # TODO - Add validation that name cannot be more than 60 characters. Update front-end to reflect this.
  # TODO - Add validation that the preface cannot be more than 1000(?) characters (it should match a limit on the front-end)

  pg_search_scope :search_by_recipe_name_ingredient_food_and_tag_name,
    against: { name: 'A' },
    associated_against: {
      ingredients: { food: 'C' },
      tags: { name: 'B' }
    },
    using: {
      tsearch: { prefix: true, dictionary: 'english' }
    }

  def small_photo_url
    if small_photo.attached?
      small_photo.blob.service_url
    end
  end

  def large_photo_url
    if large_photo.attached?
      large_photo.blob.service_url
    end
  end
end
