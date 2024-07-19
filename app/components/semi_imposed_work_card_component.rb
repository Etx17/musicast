# frozen_string_literal: true

class SemiImposedWorkCardComponent < ViewComponent::Base
  with_collection_parameter :semi_imposed_work

  def initialize(semi_imposed_work:)
    @semi_imposed_work = semi_imposed_work
  end

end
