# frozen_string_literal: true

module Table
  class BaseComponent < ViewComponent::Base
    attr_reader :rows, :selectable, :columns, :timestamp_column, :links, :client, :checkbox_options

    def initialize(rows:, columns:, client:, selectable: false, timestamp_column: nil, links: [], image_column: nil, no_action: false, empty_message: nil, checkbox_options: nil)
      @rows = rows
      @columns = columns
      @selectable = selectable
      @timestamp_column = timestamp_column
      @links = links
      @client = client
      @image_column = image_column
      @no_action = no_action
      @empty_message = empty_message
      @checkbox_options = checkbox_options
      super()
    end

    private

    def checkbox_color
      @client.button_color
    end

    def sort_indicator(column, async_url: nil)
      return unless column[:sortable]

      current_direction = (params[:direction] == "desc") ? "desc" : "asc"
      new_direction = (current_direction == "asc") ? "desc" : "asc"

      is_current_column = column[:sort_key] == params[:sort]

      direction_indicator = if is_current_column
        icon_class = (new_direction == "desc") ? "fas fa-sort-up" : "fas fa-sort-down"
        content_tag(:i, "", class: icon_class, style: "vertical-align:center;")
      else
        content_tag(:i, "", class: "fas fa-sort", style: "vertical-align:center;")
      end

      query_parameters = request.query_parameters.merge(sort: column[:sort_key], direction: new_direction)

      url = async_url ? "#{async_url}?#{query_parameters.to_query}" : url_for(query_parameters)

      link_to(direction_indicator, url, class: "sort-indicator")
    end
  end
end
