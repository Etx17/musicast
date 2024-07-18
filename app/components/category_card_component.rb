# frozen_string_literal: true

class CategoryCardComponent < ViewComponent::Base
  def initialize(category:)
    @category = category
  end

end
