class AccountPolicy < ApplicationPolicy
  def show?
    !!user
  end

  def update?
    !!user && !!record && record == user
  end
end
