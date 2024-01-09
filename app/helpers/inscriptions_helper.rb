module InscriptionsHelper
  def buttons_for_inscription(inscription)
    buttons = []
    view_button = link_to 'Voir', organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription), class: 'btn btn-primary'
    buttons << view_button

    case inscription.status
    when 'in_review'
      buttons << button_to('Accept', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, data: { turbo_confirm: 'Are you sure?' }, class: 'btn btn-success')
      buttons << button_to('Reject', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, data: { turbo_confirm: 'Are you sure?' }, class: 'btn btn-danger')
    when 'accepted'
      buttons << button_to('Reject', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'rejected'), method: :patch, data: { turbo_confirm: 'Are you sure?' }, class: 'btn btn-danger')
    when 'rejected'
      buttons << button_to('Accept', update_status_organism_competition_edition_competition_category_inscription_path(inscription.organism, inscription.competition, inscription.edition_competition, inscription.category, inscription, status: 'accepted'), method: :patch, data: { turbo_confirm: 'Are you sure?' }, class: 'btn btn-success')
    end

    buttons.join.html_safe
  end
end
