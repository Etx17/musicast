class OrganismPolicy < ApplicationPolicy

  def show?
    user_is_the_organisateur?
  end

  def new?
    user.organisateur.present?
  end

  def create?
    user.organisateur.present?
  end

  def edit?
    user_is_the_organisateur?
  end

  def update?
    edit?
  end

  def destroy?
    user_is_the_organisateur?
  end

  private

  def user_is_the_organisateur?
    user.organisateur.present? && user.organisateur == record.organisateur
  end
end
