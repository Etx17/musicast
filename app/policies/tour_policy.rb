class TourPolicy < ApplicationPolicy
  def show?
    allowed_to_edit?
  end

  def new?
    user.organisateur.present?
  end

  def create?
    user.organisateur.present?
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
    if user.organisateur
      record.has_same_organisateur_as?(user.organisateur.id)
    else
      false
    end
  end
end
