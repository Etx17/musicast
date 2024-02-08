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
end
