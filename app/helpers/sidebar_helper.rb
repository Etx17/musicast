module SidebarHelper
  def sidebar_links
    links = []

    if user_signed_in?
      if current_user.candidat.present?
        links << { label: content_tag(:i, '', class: 'fis fi-rs-home pe-2') + I18n.t('sidebar.home'), url: candidat_dashboard_path() }
        links << { label: content_tag(:i, '', class: 'fis fi-rs-user pe-2') + I18n.t('sidebar.profile'), url: candidat_path(current_user.candidat) }
        user_inscriptions = current_user.candidat.inscriptions.includes(:category)
        user_inscriptions.each do |inscription|
          status_indicator = case inscription.status
                             when 'accepted'
                               content_tag(:i, '', class: "fas fa-circle fa-xs text-success ms-2", title: inscription.status.humanize)
                             when 'in_review'
                               content_tag(:i, '', class: "fas fa-circle text-info fa-xs ms-2", title: inscription.status.humanize)
                             else
                               content_tag(:i, '', class: "fas fa-circle fa-xs text-warning fa-xs ms-2", title: inscription.status.humanize)
                             end
          base_label = content_tag(:i, '', class: 'fi fi-rs-music-alt pe-2') + inscription.category.name
          label_with_status = base_label + status_indicator
          links << {
            label: label_with_status,
            url: inscription_path(inscription)
          }
        end
      elsif current_user.organisateur.present?
        links << { label: content_tag(:i, '', class: 'fi fi-rs-dashboard pe-2') + I18n.t('sidebar.dashboard'), url: organisateur_dashboard_path() }

        current_user.organisateur.competitions.each do |competition|
          last_edition_competition = competition.edition_competitions.order(annee: :desc).first

          if last_edition_competition
            base_label = content_tag(:i, '', class: 'fi fi-rs-trophy pe-2') + "#{competition.nom_concours.truncate(17)} #{last_edition_competition.annee}"

            edition_status_color = last_edition_competition.status == 'published' ? 'text-success' : 'text-warning'
            edition_status_dot = content_tag(:i, '', class: "fas fa-circle fa-xs #{edition_status_color} ms-2")
            edition_label_with_status = base_label + edition_status_dot

            edition_link = {
              label: edition_label_with_status,
              url: organism_competition_edition_competition_path(competition.organism_id, competition.id, last_edition_competition),
              children: [],
              collapsible: true,
              collapsed: true
            }

            categories = last_edition_competition.categories
            if categories.present?
              categories.each do |category|
                category_status_color = category.status == 'published' ? 'text-success' : 'text-warning'
                category_status_dot = content_tag(:i, '', class: "fas fa-circle fa-xs #{category_status_color} ms-2")

                category_base_label = content_tag(:i, '', class: 'fi fi-rs-music-alt pe-2') + "#{category.name}"
                category_label_with_status = category_base_label + category_status_dot

                # Add category with its actions as collapsible children
                category_link = {
                  label: category_label_with_status,
                  url: organism_competition_edition_competition_category_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category),
                  collapsible: true,
                  collapsed: true,
                  children: []
                }

                # Add category actions
                category_link[:children] << {
                  label: content_tag(:i, '', class: 'fas fa-users pe-2') + I18n.t('sidebar.candidates_list'),
                  url: candidates_organism_competition_edition_competition_category_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category)
                }

                category_link[:children] << {
                  label: content_tag(:i, '', class: 'fas fa-clipboard-list pe-2') + I18n.t('sidebar.inscriptions'),
                  url: organism_competition_edition_competition_category_inscriptions_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category)
                }

                # Add rounds (tours) if they exist
                category.tours.each do |round|
                  category_link[:children] << {
                    label: content_tag(:i, '', class: 'fas fa-medal pe-2') + "#{round.title}",
                    url: organism_competition_edition_competition_category_tour_path(last_edition_competition.competition.organism_id, last_edition_competition.competition_id, last_edition_competition, category, round)
                  }
                end

                edition_link[:children] << category_link
              end
            end

            links << edition_link
          end
        end

      elsif current_user.jury
        links << { label: content_tag(:i, '', class: 'fas fa-user pe-2') + I18n.t('sidebar.profile'), url: edit_jury_path(current_user.jury), dropdown: false }
        links << { label: content_tag(:i, '', class: 'fas fa-gavel pe-2') + I18n.t('sidebar.home'), url: jury_dashboard_path(), dropdown: false }
      elsif current_user.admin?
        links << { label: content_tag(:i, '', class: 'fas fa-tachometer-alt pe-2') + I18n.t('sidebar.admin_dashboard'), url: admin_dashboard_path() }

        # Add admin categories section
        admin_categories = Category.all.includes(:edition_competition)
        if admin_categories.present?
          admin_categories_link = {
            label: content_tag(:i, '', class: 'fas fa-list pe-2') + I18n.t('sidebar.categories'),
            url: admin_categories_path(),
            collapsible: true,
            collapsed: true,
            children: []
          }

          admin_categories.each do |category|
            category_link = {
              label: content_tag(:i, '', class: 'fi fi-rs-music-alt pe-2') + "#{category.name}",
              url: admin_category_path(category),
              collapsible: true,
              collapsed: true,
              children: []
            }

            # Add category actions for admin
            category_link[:children] << {
              label: content_tag(:i, '', class: 'fas fa-users pe-2') + I18n.t('sidebar.candidates_list'),
              url: admin_category_candidates_path(category)
            }

            category_link[:children] << {
              label: content_tag(:i, '', class: 'fas fa-clipboard-list pe-2') + I18n.t('sidebar.inscriptions'),
              url: admin_category_inscriptions_path(category)
            }

            # Add rounds (tours) if they exist
            category.tours.each do |round|
              category_link[:children] << {
                label: content_tag(:i, '', class: 'fas fa-medal pe-2') + "#{round.title}",
                url: admin_category_tour_path(category, round)
              }
            end

            admin_categories_link[:children] << category_link
          end

          links << admin_categories_link
        end
      end
    else
      links << { label: content_tag(:i, '', class: 'fas fa-sign-in-alt pe-2') + I18n.t('sidebar.sign_in'), url: new_user_session_path() }
      links << { label: content_tag(:i, '', class: 'fas fa-user-plus pe-2') + I18n.t('sidebar.sign_up'), url: new_user_registration_path() }
    end

    links
  end
end
