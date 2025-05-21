# frozen_string_literal: true

class RequirementItemComponent < ViewComponent::Base
  def initialize(requirement_item:)
    @requirement_item = requirement_item
  end

  def before_render
    @description = I18n.locale == :en && @requirement_item.description_item_english.present? ?
      @requirement_item.description_item_english :
      @requirement_item.description_item
  end
end
