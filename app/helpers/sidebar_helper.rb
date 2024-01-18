module SidebarHelper
  def sidebar_links
    links = []

    if user_signed_in?
      if current_user.candidat.present?
        links << { label: "Accueil", url: candidat_dashboard_path }
        links << { label: "Profil", url: candidat_path(current_user.candidat) }
        links << { label: "Candidatures", url: inscriptions_path }
        # links << { label: "Candidat Messages", url: candidat_messages_path(current_user.candidat) }
      elsif current_user.organisateur.present?
        last_edition_competition = current_user.organisateur.competitions.last.edition_competitions.last
        links << { label: "#{last_edition_competition.competition.nom_concours} #{last_edition_competition.annee}", url: organism_competition_edition_competition_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition) }
        links << { label: "Dashboard", url: organisateur_dashboard_path }
        links << { label: "Candidatures", url: inscriptions_path }
      elsif current_user.jury?
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
