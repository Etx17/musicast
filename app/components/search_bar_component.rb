# frozen_string_literal: true

class SearchBarComponent < ViewComponent::Base
  attr_reader :search_path, :clear_path, :search_param, :placeholder, :current_search_term

  # @param search_path [String] The path to submit the search form to
  # @param clear_path [String] The path to clear the search (typically the current path without query params)
  # @param search_param [String] The parameter name to use for the search term
  # @param placeholder [String] Placeholder text for the search input
  # @param current_search_term [String] The current search term (if any)
  def initialize(
    search_path:,
    clear_path:,
    search_param: 'q',
    placeholder: nil,
    current_search_term: nil
  )
    @search_path = search_path
    @clear_path = clear_path
    @search_param = search_param
    @placeholder = placeholder || I18n.t('global.actions.search')
    @current_search_term = current_search_term

    super
  end

  def search_active?
    current_search_term.present?
  end
end
