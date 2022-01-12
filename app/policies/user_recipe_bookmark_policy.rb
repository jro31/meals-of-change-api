class UserRecipeBookmarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # TODO
    end
  end

  def create?
    !!user
  end

  def destroy?
    # TODO
  end
end
