# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(text:, path:, icon: "", button_type: "primary", data: {}, target: nil)
    super()
    @icon = icon
    @text = text
    @path = path
    @button_type = button_type
    @data = data
    @targ
  end

  def button_classes
    case @button_type
    when "primary"
      "btn btn-primary text-white"
    when "primary-bigger"
      "btn btn-primary btn-lg text-white"
    when "secondary"
      "btn btn-outline-secondary"
    when "secondary-bigger"
      "btn text-client-primary btn-lg border-client-primary"
    when "tertiary"
      "btn btn-link"
    else
      "btn btn-primary"
    end
  end
end
