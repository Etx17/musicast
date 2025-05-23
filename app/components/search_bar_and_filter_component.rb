class SearchBarAndFilterComponent < ViewComponent::Base
  def initialize(search_path:, client:, clear_path:, show_filter_mobile: true, filters_options: [], buttons: [], filter_id: nil, settings_path: nil, remote: false, format: "html", show_search_bar: true, params: {})
    super()
    @search_path = search_path
    @filters_options = filters_options
    @buttons = buttons
    @client = client
    @clear_path = clear_path
    @settings_path = settings_path
    @remote = remote
    @format = format
    @show_search_bar = show_search_bar
    @filter_id = filter_id
    @hidden_params = params
  end


  def filter_text
    params.dig(:filters, :text)
  end

  def filters_applied
  # count
  end
end
