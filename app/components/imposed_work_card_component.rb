# frozen_string_literal: true

class ImposedWorkCardComponent < ViewComponent::Base
  def initialize(category:)
    @category = category
  end

  def before_render
    imposed_work = @category.imposed_work

    @title = I18n.locale == :en && imposed_work.title_english.present? ?
      imposed_work.title_english :
      imposed_work.title

    @guidelines = I18n.locale == :en && imposed_work.guidelines_english.present? ?
      imposed_work.guidelines_english :
      imposed_work.guidelines
  end
end
