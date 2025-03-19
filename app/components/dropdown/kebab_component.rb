# frozen_string_literal: true

# kebab dropdown component that displays a list of link items which is shown based on the user's permissions
# this dropdown item is shown based on the position of the button, whether on the left or right of the page
class Dropdown::KebabComponent < ViewComponent::Base
  attr_reader :items, :align

  # DropdownItem is a struct that contains the following attributes:
  # - icon: the icon to be displayed on the left of the text (fontawesome icon).
  # - text: the text/label to be displayed.
  # - hint: title attribute, displayed when positioning the mouse over the item.
  # - path: the path to be redirected to when the item is clicked.
  # - data: data attributes for modals, etc.
  # - id: id class attribute.
  # - state: "enabled" or "disabled". If not specified, it will be "enabled".
  # - show_item: true/false. If not specified, it will always be shown.
  DropdownItem = Struct.new(:icon, :text, :action, :hint, :path, :method, :remote, :target, :show_item, :data, :id, :class,
    :state, :load_modal, keyword_init: true) do
    def initialize(*_args)
      super
      self.load_modal ||= false
      self.show_item = true if show_item.nil?
      self.state = "enabled" if state.nil?
      self.method = "get" if method.nil? && !load_modal
      self.remote = false if remote.nil?
      self.hint = text if hint.nil? && text.present?

      # Ensure data hash exists
      self.data ||= {}

      # Add turbo-method for delete actions
      if self.method == :delete || self.method == "delete"
        self.data[:turbo_method] = "delete"
      end
    end
  end

  # @param [Array<DropdownItem>] items
  # @param [Symbol] align. :left or :right. If not specified, it will be :right.
  # @param [Boolean] rounded. Rounded is the style for the card's top kebab button, otherwise it's squared.
  # @param [Boolean] only_vertical_dots. Use vertical dots style
  def initialize(items:, align: :right, rounded: false, only_vertical_dots: false)
    super()
    @items = items.map { |item| DropdownItem.new(item) }
    @align = align
    @rounded = rounded
    @only_vertical_dots = only_vertical_dots
  end
end
