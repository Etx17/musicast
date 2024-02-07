module CategoriesHelper
  def badge_with_icon(category, text, condition_method)
    color = category.send(condition_method) ? 'success' : 'secondary'
    icon = category.send(condition_method) ? 'fa-check' : 'fa-spinner'
    content_tag :span, class: "badge rounded-pill bg-#{color}-secondary text-#{color} border border-#{color}" do
      concat content_tag(:i, '', class: "fas #{icon}")
      concat " "
      concat text
    end
  end
end
