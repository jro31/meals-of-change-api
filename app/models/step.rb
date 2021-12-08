class Step < ApplicationRecord
  belongs_to :recipe

  # Validates presence of position?
  validates_presence_of :instructions
end
