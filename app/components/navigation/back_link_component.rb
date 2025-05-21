# frozen_string_literal: true

# back link for going back to homepage or other pages
class Navigation::BackLinkComponent < ViewComponent::Base
  def initialize(link_path:, link_text:)
    super()
    @link_path = link_path
    @link_text = link_text
  end
end
