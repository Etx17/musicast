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

  # View button
  buttons << link_to(organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription),
    class: 'btn bg-secondary-secondary btn-sm w-100',
    target: '_blank') do
      concat content_tag(:i, '', class: 'fas fa-eye me-1 text-secondary')
      concat I18n.t('global.actions.view')
  end

  if inscription.category.payment_after_approval
    case inscription.status
    when 'in_review'
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'approved_waiting_payment'),
        method: :patch,
        class: 'btn btn-sm w-100 bg-success-secondary') do
          concat content_tag(:i, '', class: 'fa fa-check me-1 text-success ')
          concat I18n.t('global.actions.accept_wait_payment')
      end

      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'),
        method: :patch,
        class: 'btn bg-secondary-secondary btn-sm w-100') do
          concat content_tag(:i, '', class: 'fa fa-times me-1 text-danger')
          concat I18n.t('global.actions.reject')
      end

    when 'approved_waiting_payment', 'new_payment_submitted'
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'payment_error_waiting_payment', payment_status: 'payment_error'),
        method: :patch,
        class: 'btn btn-sm w-100 bg-secondary-secondary') do
          concat content_tag(:i, '', class: 'fa fa-exclamation-triangle me-1 text-danger')
          concat I18n.t('global.actions.report_payment_error')
      end
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted', payment_status: 'paid'),
        method: :patch,
        class: 'btn btn-sm w-100 bg-success-secondary') do
          concat content_tag(:i, '', class: 'fa fa-check me-1 text-success')
          concat I18n.t('global.actions.confirm_payment')
      end

    end
  else
    case inscription.status
    when 'in_review'
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'),
        method: :patch,
        class: 'btn btn-sm w-100 bg-success-secondary') do
          concat content_tag(:i, '', class: 'fa fa-check me-1 text-success')
          concat I18n.t('global.actions.accept')
      end

      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'),
        method: :patch,
        class: 'btn bg-secondary-secondary btn-sm w-100') do
          concat content_tag(:i, '', class: 'fa fa-times me-1 text-danger')
          concat I18n.t('global.actions.reject')
      end

    when 'accepted'
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'),
        method: :patch,
        class: 'btn bg-secondary-secondary btn-sm w-100') do
          concat content_tag(:i, '', class: 'fa fa-times me-1 text-danger')
          concat I18n.t('global.actions.reject')
      end

    when 'rejected'
      buttons << button_to(update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'),
        method: :patch,
        class: 'btn bg-success-secondary btn-sm w-100') do
          concat content_tag(:i, '', class: 'fa fa-check me-1 text-success')
          concat I18n.t('global.actions.accept')
      end
    end
  end

  content_tag(:div, safe_join(buttons, ' '), class: 'd-flex flex-column w-100 gap-1')
end

  def inscription_status_icon(inscription)
    case inscription.status
    when 'draft'
      content_tag(:i, '', class: 'fi fi-rs-document text-secondary')
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

  def score_badge(score)
    return if score.nil? || score.zero? || score.is_a?(String)

    badge_class = case score
                  when 0..50
                    "bg-danger-secondary text-danger"
                  when 51..75
                    "bg-warning-secondary text-warning"
                  else
                    "bg-success-secondary text-success"
                  end

    content_tag(:span, "#{score}/100", class: "badge #{badge_class} rounded-pill")
  end
end
