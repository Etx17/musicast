class Card::BaseComponent < ViewComponent::Base
  attr_reader :height, :image, :links, :redirect, :bottom_left_label, :bottom_button_links, :ratio, :image_style, :highlight_card, :bottom_left_pill, :top_left_pill
  def initialize(
    height: 570,
    image: nil,
    links: nil,
    redirect: nil,
    bottom_left_label: nil,
    bottom_button_links: [],
    ratio: "350/235",
    has_shadow: false,
    top_left_pill: nil,
    bottom_left_pill: nil,
    image_style: nil,
    highlight_card: false
  )
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
