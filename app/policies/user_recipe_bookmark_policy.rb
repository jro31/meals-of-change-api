class UserRecipeBookmarkPolicy < ApplicationPolicy
  def create?
    !!user
  end

  def bookmark_id?
    !!user
  end

  def destroy?
    !!user && record.user == user
  end
end
