# frozen_string_literal: true

class SemiImposedWorkCardComponent < ViewComponent::Base
  with_collection_parameter :semi_imposed_work

  def initialize(semi_imposed_work:)
    @semi_imposed_work = semi_imposed_work
  end

  def before_render
    @title = I18n.locale == :en && @semi_imposed_work.title_english.present? ?
      @semi_imposed_work.title_english :
      @semi_imposed_work.title

    @guidelines = I18n.locale == :en && @semi_imposed_work.guidelines_english.present? ?
      @semi_imposed_work.guidelines_english :
      @semi_imposed_work.guidelines
  end
end
