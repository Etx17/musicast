# frozen_string_literal: true

class SingleFilterComponent < ViewComponent::Base
  attr_reader :filter_path, :clear_path, :filter_param, :options, :selected_value, :label

  # @param filter_path [String] The path to submit the filter form to
  # @param clear_path [String] The path to clear the filter (typically the current path without query params)
  # @param filter_param [String] The parameter name to use for the filter
  # @param options [Array<Array>] Array of option pairs [label, value]
  # @param selected_value [String] The currently selected filter value
  # @param label [String] The label for the filter dropdown
  def initialize(
    filter_path:,
    clear_path:,
    filter_param: 'filter',
    options: [],
    selected_value: nil,
    label: nil
  )
    @filter_path = filter_path
    @clear_path = clear_path
    @filter_param = filter_param
    @options = options
    @selected_value = selected_value
    @label = label || I18n.t('global.actions.filter')

    super
  end

  def filter_active?
    selected_value.present?
  end
end
