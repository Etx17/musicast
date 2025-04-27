# module InscriptionsHelper
#   def buttons_for_inscription(inscription)
#     buttons = []
#     view_button = link_to 'Voir dossier', organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription), class: 'btn btn-success btn-sm', target: '_blank'
#     buttons << view_button

#     case inscription.status
#     when 'in_review'
#       buttons << button_to(' Accept', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, class: 'btn btn-success btn-sm')
#       buttons << button_to('Reject', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, class: 'btn btn-outline-danger btn-sm')
#     when 'accepted'
#       buttons << button_to('Reject', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, class: 'btn btn-outline-danger btn-sm')
#     when 'rejected'
#       buttons << button_to('Accept', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, class: 'btn btn-outline-success btn-sm')
#     end

#     buttons.join.html_safe
#   end
# end
module InscriptionsHelper
  def buttons_for_inscription(inscription)
    buttons = []
    view_button = link_to I18n.t('global.actions.view'), organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription), class: 'btn btn-outline-dark btn-sm  ', target: '_blank'
    buttons << view_button

    if inscription.category.payment_after_approval
      case inscription.status
      when 'in_review'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'approved_waiting_payment'), method: :patch, class: 'btn btn-success border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-check accept-inscription')
          concat ' Accept (wait for payment)'
        end
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, class: 'btn btn-outline-secondary border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-times')
          concat ' Reject'
        end
      when 'approved_waiting_payment'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted', payment_status: 'paid'), method: :patch, class: 'btn btn-success border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-check accept-inscription')
          concat 'Accept'
        end
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'payment_error_waiting_payment', payment_status: 'payment_error'), method: :patch, class: 'btn btn-outline-danger border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-exclamation-triangle')
          concat 'Payment error'
        end
      when 'payment_error_waiting_payment'
      when 'new_payment_submitted'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted', payment_status: 'paid'), method: :patch, class: 'btn btn-success border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-check accept-inscription')
          concat 'Accept'
        end

        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'payment_error_waiting_payment', payment_status: 'payment_error'), method: :patch, class: 'btn btn-outline-danger border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-exclamation-triangle')
          concat 'Payment error'
        end
      end
    else
      case inscription.status
      when 'in_review'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, class: 'btn btn-success border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-check accept-inscription')
          concat ' Accept'
        end
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, class: 'btn btn-outline-secondary border border-0  btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-times')
          concat ' Reject'
        end
      when 'accepted'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, class: 'btn btn-outline-danger border border-0 btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-times')
          concat ' Reject'
        end
      when 'rejected'
        buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, class: 'btn btn-outline-success btn-sm') do
          concat content_tag(:i, '', class: 'fa fa-check')
          concat ' Accept'
        end
      end
    end

    safe_join(buttons)
  end

  def inscription_status_icon(inscription)
    case inscription.status
    when 'draft'
      content_tag(:i, '', class: 'fa fa-file')
    when 'in_review'
      content_tag(:i, '', class: 'fas fa-spinner text-secondary')
    when 'accepted'
      content_tag(:i, '', class: 'fa fa-check-circle text-success')
    when 'rejected'
      content_tag(:i, '', class: 'fas fa-times-circle text-danger')
    end
  end

  def inscriptions_status_keys_for_table(category)
    if category.payment_after_approval
      Inscription.statuses.keys
    else
      Inscription.statuses.keys.reject { |status| status == 'approved_waiting_payment' || status == 'payment_error_waiting_payment' || status == 'new_payment_submitted' }
    end
  end

  def should_display_payment_section?(inscription)
    return true if inscription.status == "payment_error_waiting_payment"
    return true if inscription.category.payment_after_approval && ["approved_waiting_payment", "accepted", "payment_error_waiting_payment", "rejected", "new_payment_submitted"].include?(inscription.status)
    return true if !inscription.category.payment_after_approval
    false
  end

  def get_status_color(status)
    case status
    when 'draft'
      'secondary'
    when 'in_review'
      'info'
    when 'request_changes'
      'warning'
    when 'approved_waiting_payment'
      'primary'
    when 'payment_error_waiting_payment'
      'danger'
    when 'new_payment_submitted'
      'info'
    when 'accepted'
      'success'
    when 'rejected'
      'danger'
    else
      'secondary'
    end
  end

  def get_payment_status_color(payment_status)
    case payment_status
    when 'no_proof_joined_yet'
      'secondary'
    when 'waiting_for_approval'
      'info'
    when 'paid'
      'success'
    when 'payment_error'
      'danger'
    else
      'secondary'
    end
  end
end
