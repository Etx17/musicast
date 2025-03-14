class InscriptionPolicy < ApplicationPolicy

  def jury_index?
    record&.first&.category_id.in?(user.jury.categories_juries.pluck(:category_id)) if user.jury.present?
  end

  def show?
    return true if user.jury.present? && record.category_id.in?(user.jury.categories_juries.pluck(:category_id))
    allowed_to_edit?
  end

  def create?
    true
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

  def request_changes?
    record.has_same_organisateur_as?(user.organisateur.id)
  end

  # class Scope < Scope
  #   def resolve
  #     scope.includes(inscription: [:candidat, { category: { edition_competition: { competition: { organism: :organisateur } } } }])
  #           .where(inscriptions: { candidat: user.candidat })
  #   end
  # end

  private

  def allowed_to_edit?
    if user.organisateur
      record.has_same_organisateur_as?(user.organisateur.id)
    elsif user.candidat
      user.candidat == record.candidat
    else
      false
    end
  end
end
