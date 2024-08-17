module BootstrapHelper

  def question(message, wrapper_class: '')
    content_tag :div, class: wrapper_class do
      concat content_tag :span, fa_question_circle, class: 'text-primary'
      concat message
    end
  end

  def container(options={}, &block)
    options[:for] = nil if options[:for].blank?

    content_tag :div, class: [['container', options[:for]].compact.join('-'), "p-#{options[:p] || 2}", options[:class]].flatten, style: options[:style], data: options[:data], id: options[:id] do
      concat capture(&block)
    end
  end

  def row(options={}, &block)
    content_tag :div, class: ["row #{'justify-content-center' unless options[:class].present?}", "g-#{options[:g] || 2}", options[:class]].flatten, data: { mansory: { percentPosition: options[:mansory] } }.merge(options[:data] || {}), style: options[:style], id: options[:id] do
      concat capture(&block)
    end
  end

  def col(options={}, &block)
    xxl = options [:xxl] || options[:xl] || options[:lg] || options[:md] || options[:sm] || options[:xs]
    xl  =                   options[:xl] || options[:lg] || options[:md] || options[:sm] || options[:xs]
    lg  =                                   options[:lg] || options[:md] || options[:sm] || options[:xs]
    md  =                                                   options[:md] || options[:sm] || options[:xs]
    sm  =                                                                   options[:sm] || options[:xs]
    xs  =                                                                                   options[:xs]
    klass = "col-#{options[:all]}" if options[:all].present?
    klass ||= "col-xxl-#{xxl || 4} col-xl-#{xl || 4} col-lg-#{lg || 6} col-md-#{md || 6} col-sm-#{sm || 12} col-#{xs || 12}"

    custom_class = options[:class] if options[:class].is_a?(String)
    custom_class = options[:class].join(' ') if options[:class].is_a?(Array)
    klass += " #{custom_class}" if custom_class.present?
    content_tag :div, class: klass, style: options[:style], id: options[:id] do
      concat capture(&block)
    end
  end


  def grid(options={}, &block)
    content_tag :div, class: ['grid', "gap-#{options[:gap] || 0}", "row-gap-#{options[:row_gap] || 0}", "columns-gap-#{options[:columns_gap] || 0}"], data: { mansory: { percentPosition: options[:mansory] } }.merge(options[:data] || {}) do
      concat capture(&block)
    end
  end

  def g_col(options={}, &block)
    col(options.merge!(g: true), &block)
  end

  def tabs(id, tablist)
    # Tablist is an array of arrays.
    # Each array has the structure [tab_id, tab_name, tab_content] as html.

    content_tag :div do
      concat nav_tabs(id, tablist)
      concat tab_content(id, tablist)
    end
  end

  def nav_tabs(id, tablist)
    content_tag :ul, class: 'nav nav-tabs nav-fill', id: id, role: 'tablist' do
      tablist.each do |tab|
        concat content_tag :li, tab_button(tablist, tab), class: 'nav-item', role: 'presentation'
      end
    end
  end

  def tab_button(tablist, tab)
    current = tab == tablist.first
    classes = %w[nav-link h6 p-3]
    classes.push('active') if current

    content_tag :button, class: classes, id: "#{tab[0]}-tab", data: { bs_toggle: 'tab', bs_target: "##{tab[0]}" }, type: 'button', role: 'tab', aria_controls: tab[0], aria_selected: current do
      concat tab[1]
    end
  end

  def tab_content(id, tablist)
    # The id is generated dynamically to include Content. Pass the id from the tabs helper.
    content_tag :div, id: "#{id}Content", class: 'tab-content p-3 border-start border-end border-bottom' do

      tablist.each do |tab|
        current = tab == tablist.first
        classes = %w[tab-pane fade]
        classes.push('show', 'active') if current
        concat content_tag :div, tab[2], id: tab[0], class: classes, role: 'tabpanel', aria_labelledby: "#{tab[0]}-tab"
      end
    end
  end
end
