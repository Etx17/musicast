class CandidatPolicy < ApplicationPolicy
  attr_reader :user, :record


  def show?
    true
  end

  def create?
    true
  end

  def edit?
    user.candidat == record
  end

  def update?
    user.candidat == record
  end

  def destroy?
    user.candidat == record
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

end
