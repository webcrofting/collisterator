class ListTypePolicy < ApplicationPolicy
  def edit?
    user.admin? || user.payer?
  end

  def create?
    user.admin? || user.payer?
  end
end
