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

  def download_warmup_schedule?
    edit?
  end

  def download_pianist_rehearsal_schedule?
    edit?
  end

  def download_room_pianist_rehearsal_schedule?
    edit?
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
