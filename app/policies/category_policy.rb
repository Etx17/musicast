class CategoryPolicy < ApplicationPolicy
  def show?
    allowed_to_edit?
  end

  def new?
    true
  end

  def create?
    record.edition_competition.competition.organisateur == user.organisateur
  end

  def edit?
    allowed_to_edit?
  end

  def update?
    edit?
  end

  def destroy?
    allowed_to_edit?
  end

  private

  def allowed_to_edit?
    return true if user.admin
    if user.organisateur
      record.has_same_organisateur_as?(user.organisateur.id)
    else
      false
    end
  end
end
