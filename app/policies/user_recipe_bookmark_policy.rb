class UserRecipeBookmarkPolicy < ApplicationPolicy
  def create?
    !!user
  end

  def destroy?
    !!user && record.user == user
  end
end
