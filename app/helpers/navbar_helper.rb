module NavbarHelper
  def navbar_links
    links = []

    if user_signed_in?
        links << { label: '<i class="fas fa-envelope text-secondary custom-size"></i>'.html_safe, url: "#", dropdown: false }
        links << { label: '<i class="fas fa-bell large text-secondary custom-size notification-icon"></i>'.html_safe, url: "#", dropdown: false, html_options: { id: 'notification-icon-bell' } }
      if current_user.candidat.present?
        # Add links for candidat
        # links << { label: "Candidat", url: candidat_path(current_user.candidat), dropdown: false }
        # links << { label: "Accueil", url: candidat_dashboard_path, dropdown: false }
        # Add more links for the candidat here
      elsif current_user.organisateur.present?
        # Add links for organizer
        # links << { label: "Profile", url: organisateur_path(current_user.organisateur), dropdown: true }
        # links << { label: "Tableau de bord", url: organisateur_dashboard_path, dropdown: true }
        # Add more links for the organizer here
      elsif current_user.jury
        # Add links for jury
        links << { label: t("global.profile"), url: edit_jury_path(current_user.jury), dropdown: false }
        links << { label: t("global.home"), url: jury_dashboard_path, dropdown: false }
        # Add more links for the jury here
      else
        # Add general links
        # links << { label: "User", url: user_path(current_user), dropdown: false }
        # links << { label: "Dashboard", url: user_dashboard_path, dropdown: false }
        # Add more links for the user here
      end
    else
      # links << { label: t("global.offer"), url: pages_pricing_path, dropdown: false }
      links << { label: t("navbar.home"), url: root_path, dropdown: false }
      links << { label: t("global.actions.login"), url: new_user_session_path, dropdown: false }
      links << { label: t("global.actions.create_account"), url: new_user_registration_path, dropdown: false }
    end

    links
  end


  def navbar_links_for_profile_pic
    [
      # { label: 'Mon compte', url: edit_user_registration_path },
      # { label: 'Moyens de paiement', url: "#" },
      { label: t("global.actions.logout"), url: destroy_user_session_path, method: :delete },
      { label: t("global.actions.change_password"), url: edit_user_registration_path }
    ]
  end
end
