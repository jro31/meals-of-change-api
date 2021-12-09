class RecipePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    !!user
  end
end
