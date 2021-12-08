class Step < ApplicationRecord
  belongs_to :recipe

  validates_presence_of :position, :instructions
  validates_uniqueness_of :position
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
