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
        links << { label: content_tag(:i, '', class: 'fas fa-home') + " Tableau de bord", url: organisateur_dashboard_path }

        current_user.organisateur.competitions.each do |competition|
          last_edition_competition = competition.edition_competitions.last

          if competition.edition_competitions.present?
            edition_link = {
              label: content_tag(:i, '', class: 'fas fa-trophy text-secondary') + " #{competition.nom_concours} #{last_edition_competition.annee}",
              url: organism_competition_edition_competition_path(competition.organism_id, competition.id, last_edition_competition),
              status: last_edition_competition.status,
              children: []
            }

            categories = last_edition_competition.categories
            if categories.present?
              categories.each do |category|
                edition_link[:children] << {
                  label: content_tag(:i, '', class: 'fas fa-music text-secondary') + " #{category.name}",
                  url: organism_competition_edition_competition_category_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category)
                }
              end
            end

            links << edition_link
          end
        end

      elsif current_user.jury
        links << { label: "Profil", url: edit_jury_path(current_user.jury), dropdown: false }
        links << { label: "Accueil", url: jury_dashboard_path, dropdown: false }
        # links << { label: "Candidatures", url: inscriptions_path }
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
