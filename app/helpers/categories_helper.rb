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

  def category_discipline_image(category)
    # Images left to add:

    # bassoon: 3,
    # cello: 4,
    # chamber_music: 5,
    # choirs_and_choral_singing: 6,
    # clarinet: 7,
    # composition_and_musical_writing: 8,
    # double_bass: 9,
    # flute: 10,
    # guitar: 11,
    # harp: 12,
    # horn: 13,
    # oboe: 15,
    # orchestration_and_orchestra_conducting: 16,
    # percussion: 17,
    # trombone: 19,
    # trumpet: 20,
    # tuba: 21,
    image_tag("disciplines/#{category.discipline}.png", class: 'img-fluid', style: 'object-fit: cover; ')
  rescue
    image_tag('disciplines/violin.jpg', class: 'img-fluid', style: 'object-fit: cover; ')
  end
end
