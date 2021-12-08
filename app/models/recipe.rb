class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy

  validates_presence_of :name
end
