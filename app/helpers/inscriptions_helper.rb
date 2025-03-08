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
    view_button = link_to 'Voir dossier', organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription), class: 'btn btn-outline-dark btn-sm  ', target: '_blank'
    buttons << view_button

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
end
