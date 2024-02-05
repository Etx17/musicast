module SidebarHelper
  def sidebar_links
    links = []

    if user_signed_in?
      if current_user.candidat.present?
        links << { label: "Accueil", url: candidat_dashboard_path }
        links << { label: "Profil", url: candidat_path(current_user.candidat) }
        links << { label: "Candidatures", url: inscriptions_path }
        # Toutes les inscriptions du candidat  dont le edition_competition.end_of_registration est pas encore passé
        current_user.candidat&.inscriptions&.each do |inscription|
          links << { label: inscription.category.name, url: inscription_path(inscription), status: inscription.status }
        end
      elsif current_user.organisateur.present?
        links << { label: "Tableau de bord", url: organisateur_dashboard_path }
        last_edition_competition = current_user.organisateur&.competitions&.last&.edition_competitions&.last
        categories = last_edition_competition&.categories
        if last_edition_competition.present?
          links << {
            label: "#{last_edition_competition.competition.nom_concours} #{last_edition_competition.annee}",
            url: organism_competition_edition_competition_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition),
            status: last_edition_competition.status
          }
        end
                    if categories.present?
          categories.each do |category|
            links << { label: category.name, url: organism_competition_edition_competition_category_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category) }
          end
        end
        # links << { label: "Candidatures", url: inscriptions_path }
      elsif current_user.jury
        # links << { label: "Jury Dashboard", url: jury_dashboard_path }
        # links << { label: "Jury Decisions", url: jury_decisions_path }
        # links << { label: "Jury Messages", url: jury_messages_path }
      else
        # links << { label: "General Link 1", url: general_link1_path }
        # links << { label: "General Link 2", url: general_link2_path }
      end
    else
      links << { label: "Sign In", url: new_user_session_path }
      links << { label: "Sign Up", url: new_user_registration_path }
    end

    links
  end
end
