module RequirementItemsHelper
  def icon_for(item_type)
    case item_type
    when 'youtube_link'
      'icons/youtube.png'
    when 'recommendation_letter'
      'icons/lettre.png'
    when 'parental_authorization'
      'icons/autorisation.png'
    when 'motivation_essay'
      'icons/lettre-de-motivation.png'
    else
      'icons/lettre-de-motivation.png' # replace with your default icon
    end
  end

  def display_ratio(ratio)
    # Formatage du ratio pour l'affichage
    case ratio.to_f
    when 1.778
      "16:9"
    when 1.333
      "4:3"
    when 1.0
      "1:1"
    when 0.75
      "3:4"
    when 0.5625
      "9:16"
    else
      ratio.to_s
    end
  end
end
