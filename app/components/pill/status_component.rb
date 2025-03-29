# frozen_string_literal: true

class Pill::StatusComponent < ViewComponent::Base
  def initialize(text:, color:, border: false)
    @text = text
    @color = color
    @border = border
  end

  def border_color
    return nil unless @border

    case @color
    when 'primary'
      'border-primary'
    when 'secondary'
      'border-secondary'
    when 'success'
      'border-success'
    when 'danger'
      'border-danger'
    when 'warning'
      'border-warning'
    when 'info'
      'border-info'
    when 'light'
      'border-light'
    when 'dark'
      'border-dark'
    end
  end


  def text_color
    case @color
    when 'primary'
      'text-primary'
    when 'secondary'
      'text-secondary'
    when 'success'
      'text-success'
    when 'danger'
      'text-danger'
    when 'warning'
      'text-warning'
    when 'info'
      'text-info'
    when 'light'
      'text-light'
    when 'dark'
      'text-dark'
    end
  end

  def background_color
    case @color
    when 'primary'
      'bg-primary-light'
    when 'secondary'
      'bg-grey'
    when 'success'
      'bg-success-light'
    when 'danger'
      'bg-danger-secondary'
    when 'warning'
      'bg-warning-light'
    when 'info'
      'bg-info-secondary'
    when 'light'
      'bg-light'
    when 'dark'
      'bg-dark'
    end
  end
end
