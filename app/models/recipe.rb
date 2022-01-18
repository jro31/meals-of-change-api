class Recipe < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags
  has_many :user_recipe_bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :user_recipe_bookmarks, source: :user

  has_one_attached :small_photo
  has_one_attached :large_photo

  accepts_nested_attributes_for :ingredients, :steps

  validates_presence_of :name
  validates_length_of :preface, maximum: 2500
  validate :validate_number_of_tags
  # TODO - Add validation that at least one ingredient must exist? (will make testing a pain)
  # TODO - Add validation that at least one step must exist? (will make testing a pain)
  # TODO - Add validation that name cannot be more than 60 characters. Update front-end to reflect this.

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

  private

  def validate_number_of_tags
    return if tags.count <= 9

    errors.add(:base, 'cannot have more than 9 tags')
  end
end
