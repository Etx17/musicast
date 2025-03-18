class Card::CategoryComponent < ViewComponent::Base
  attr_reader :category

  def initialize(category:)
    @category = category
    @height = 550
    @image = category.photo.attached? ? helpers.url_for(category.photo) : "https://placehold.co/300x200"
    @redirect = nil
    @bottom_button_links = [{
      label: I18n.t('global.actions.show'),
      button_type: "primary-bigger",
      data: { bs_toggle: "modal", bs_target: "#categoryModal#{category.id}" }
    }]

    price_text = category.price_cents > 0 ?
      "#{(category.price_cents / 100.0).to_i} #{category.price_currency}" :
      I18n.t('global.free')

    @bottom_left_label = {
      icon: "€",
      label: price_text,
      class: "h5 text-primary"
    }

    @bottom_left_pill = if category.max_age.present? && category.min_age.present?
      {
        label: "#{category.min_age}-#{category.max_age} #{I18n.t('global.years')}",
        class: "badge rounded-pill bg-light text-dark"
      }
    else
      nil
    end

    @top_left_pill = nil
  end

end
