class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags

  has_one_attached :thumbnail_photo, dependent: :destroy
  has_one_attached :small_photo, dependent: :destroy
  has_one_attached :large_photo, dependent: :destroy
  has_one_attached :full_size_photo, dependent: :destroy
  # TODO - Delete from AWS if a different photo is added, or if the recipe is destroyed
  # Not sure how, but 'purge' might help - https://edgeapi.rubyonrails.org/classes/ActiveStorage/Attached/One.html#method-i-purge

  accepts_nested_attributes_for :ingredients, :steps

  validates_presence_of :name
  # TODO - Add validation that at least one ingredient must exist? (will make testing a pain)
  # TODO - Add validation that at least one step must exist? (will make testing a pain)
  # TODO - Add validation that cannot have more than 15 tags
  # TODO - Add validation that the preface cannot be more than 1000(?) characters (it should match a limit on the front-end)

  default_scope { order(created_at: :desc) } # TODO - Remove this; just sort this way where needed. This is a pain when calling, for example, Recipe.last and it returns the first recipe

  def thumbnail_photo_url
    if thumbnail_photo.attached?
      thumbnail_photo.blob.service_url
    end
  end

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

  def full_size_photo_url
    if full_size_photo.attached?
      full_size_photo.blob.service_url
    end
  end
end
