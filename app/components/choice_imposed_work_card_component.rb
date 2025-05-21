# frozen_string_literal: true

class ChoiceImposedWorkCardComponent < ViewComponent::Base
  def initialize(choice_imposed_work:)
    @choice_imposed_work = choice_imposed_work
  end

  def before_render
    @title = I18n.locale == :en && @choice_imposed_work.title_english.present? ?
      @choice_imposed_work.title_english :
      @choice_imposed_work.title

    @guidelines = I18n.locale == :en && @choice_imposed_work.guidelines_english.present? ?
      @choice_imposed_work.guidelines_english :
      @choice_imposed_work.guidelines

  end
end
