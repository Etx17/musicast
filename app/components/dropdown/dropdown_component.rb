# frozen_string_literal: true

class Dropdown::DropdownComponent < ViewComponent::Base
  attr_reader :items, :align, :icon, :label

  # DropdownItem is a struct that contains the following attributes:
  # - icon: the icon to be displayed on the left of the text (fontawesome icon).
  # - text: the text/label to be displayed.
  # - hint: title attribute, displayed when positioning the mouse over the item.
  # - path: the path to be redirected to when the item is clicked.
  # - data: data attributes for modals, etc.
  # - id: id class attribute.
  # - state: "enabled" or "disabled". If not specified, it will be "enabled".
  # - show_item: true/false. If not specified, it will always be shown.
  DropdownItem = Struct.new(:icon, :text, :hint, :path, :method, :remote, :target, :show_item, :data, :id, :class, :state, keyword_init: true) do
    def initialize(*args)
      super
      self.show_item = true if show_item.nil?
      self.state = "enabled" if state.nil?
      self.method = "get" if method.nil?
      self.remote = false if remote.nil?
      self.hint = text if hint.nil? && text.present?
    end
  end

  def initialize(label:, items:, align: "left", icon: "fa-regular fa-sliders-simple")
    super()
    @icon = icon
    @label = label
    @items = items.map { |item| DropdownItem.new(item) }
    @align = align
  end
end
