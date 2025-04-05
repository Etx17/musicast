# frozen_string_literal: true

class InfoboxComponent < ViewComponent::Base
  # ex icon: "fas fa-info-circle"
  def initialize(title: nil, icon: 'fas fa-info-circle', text: nil)
    @title = title
    @icon = icon
    @text = text
  end
end
