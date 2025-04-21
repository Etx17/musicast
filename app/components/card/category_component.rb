class Card::CategoryComponent < ViewComponent::Base
  attr_reader :category, :height, :image, :redirect, :bottom_button_links,
              :bottom_left_label, :bottom_left_pill, :top_left_pill,
              :category_name, :category_description

  def initialize(category:)
    @category = category
    @height = 550
    @image = category.photo.attached? ? nil : "https://placehold.co/300x200"
    @photo = category.photo if category.photo.attached?
    @redirect = nil
    @bottom_button_links = [{
      label: I18n.t('global.actions.show'),
      button_type: "primary-bigger",
      data: { bs_toggle: "modal", bs_target: "#categoryModal#{category.id}" }
    }]
    @price_cents = category.price_cents
    @price_currency = category.price_currency
    @min_age = category.min_age
    @max_age = category.max_age
    @discipline = category.discipline
    @prize_pool_total_amount = category.prize_pool_total_amount
    @biggest_prize_amount = category.biggest_prize_amount
  end

  def before_render
    if @photo.present?
      @image = helpers.url_for(@photo)
    end



    price_text = @price_cents > 0 ?
      helpers.humanized_money_with_symbol(Money.new(@price_cents, @price_currency)) :
      I18n.t('global.free')

    @bottom_left_label = {
      label: price_text,
      class: "h4 text-secondary"
    }

    @pills = []

    if @max_age.present? && @min_age.present?
      @pills << {
        label: "#{@min_age}-#{@max_age} #{I18n.t('global.years')}",
        class: "badge rounded-pill bg-light text-dark me-1"
      }
    end

    if @discipline.present?
      @pills << {
        label: I18n.t("discipline.#{@discipline}"),
        class: "badge rounded-pill bg-light text-dark"
      }
    end

    @bottom_left_pill = @pills.first if @pills.any?

    if @prize_pool_total_amount.present? && @prize_pool_total_amount > 0
      @top_left_pill = {
        label: "#{I18n.t('categories.card.prize_pool')}: #{helpers.humanized_money_with_symbol(@prize_pool_total_amount)}",
        class: "badge rounded-pill bg-success text-white"
      }
    end

    @monetary_prizes = @category.prizes.where(prize_type: "monetary")
    @non_monetary_prizes = @category.prizes.where(prize_type: "non_monetary")
    @recognition_prizes = @category.prizes.where(prize_type: "recognition")

    @formatted_prize_pool = if @prize_pool_total_amount.present? && @prize_pool_total_amount > 0
      helpers.humanized_money_with_symbol(@prize_pool_total_amount)
    else
      nil
    end

    @formatted_biggest_prize = if @biggest_prize_amount.present? && @biggest_prize_amount > 0
      helpers.humanized_money_with_symbol(@biggest_prize_amount)
    else
      nil
    end
  end

  private

  def rails_blob_url(blob)
    Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
  rescue => e
    "https://placehold.co/300x200"
  end
end
