# frozen_string_literal: true

class TagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end

  def create?
    user.present? # redundant because user is required to initialize a policy, but just to be safe in case that changes
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
