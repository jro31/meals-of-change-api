class AccountPolicy < ApplicationPolicy
  def show?
    !!user
  end

  def update?
    false
  end
end
