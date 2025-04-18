# frozen_string_literal: true

class Card::EditionCompetitionComponent < ViewComponent::Base
  def initialize(edition_competition:, height: 570, image: nil, has_shadow: false, links: nil, redirect: nil, bottom_left_label: nil, bottom_button_links: [], ratio: "350/235", top_left_pill: nil, bottom_left_pill: nil, image_style: nil, highlight_card: false)
    @edition_competition = edition_competition
    @height = height
    @image = image
    @has_shadow = has_shadow
    @links = links
    @redirect = redirect
    @bottom_left_label = bottom_left_label
    @bottom_button_links = bottom_button_links
    @ratio = ratio
    @top_left_pill = top_left_pill
    @bottom_left_pill = bottom_left_pill
    @image_style = image_style
    @highlight_card = highlight_card
  end
end
