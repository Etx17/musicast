class CompetitionPolicy < ApplicationPolicy

  def show?
    allowed_to_edit?
  end

  def new?
    user.organisateur.present?
  end

  def create?
    allowed_to_edit?
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
      user.organisateur == record.organisateur
    else
      false
    end
  end
end
