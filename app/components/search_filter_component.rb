class SearchFilterComponent < ViewComponent::Base
  def initialize(search_path:, client:, clear_path:, show_filter_mobile: true, filters_options: [], buttons: [], filter_id: nil, settings_path: nil, remote: false, format: "html", show_search_bar: true, params: {})
    super()
    @search_path = search_path
    @filters_options = filters_options # has a specific structure
    @buttons = buttons # has a specific structure too (see above)
    @client = client
    @clear_path = clear_path
    @settings_path = settings_path
    @remote = remote # for the form with ajax call
    @format = format # for the form that need format: js attribute, (invitees attendance tab for example)
    @show_search_bar = show_search_bar
    @filter_id = filter_id
    @show_filter_mobile = show_filter_mobile
    @hidden_params = params
  end

  # Originally method from application.html.erb, copied here for better encapsulation (rather that including Application Helper)
  def translate_for_client(name_space, item, locals = {})
    if name_space.present?
      if item[0] == "."
        item = caller_locations(1..1).first.path.split(".").first.gsub(Rails.root.to_s + "/app/views", "").split("/").join(".").gsub("._", ".") + item
      end
      item_locals = locals
      item_locals[:default] = I18n.translate(item, **locals).html_safe
      item_locals[:scope] = name_space
      item_locals[:locale] = I18n.locale
      I18n.translate(item, **item_locals).html_safe
    else
      I18n.translate(item, **locals).html_safe
    end
  end

  def filter_text
    params.dig(:filters, :text)
  end

  def filters_applied
    count = 0
    count += params[:filters_applied].to_i
    if params[:filters].present? && params[:filters][:level_skill].present?
      params[:filters][:level_skill].each do |_key, value|
        count += 1 if value.present?
      end
    end
    count
  end
end
