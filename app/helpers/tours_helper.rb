module ToursHelper
  def time_preference_color(time_preference)
    case time_preference
      
    when 'morning'
      'warning'
    when 'afternoon'
      'primary'
    else
      'secondary'
    end
  end
end
