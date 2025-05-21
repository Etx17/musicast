module ApplicationHelper

  def flag_emoji(nationality_code)
    flags = {
      "AM" => "🇦🇲", "AT" => "🇦🇹", "BY" => "🇧🇾", "BE" => "🇧🇪", "BA" => "🇧🇦",
      "BG" => "🇧🇬", "CH" => "🇨🇭", "CZ" => "🇨🇿", "DE" => "🇩🇪", "DK" => "🇩🇰",
      "EE" => "🇪🇪", "ES" => "🇪🇸", "FI" => "🇫🇮", "FR" => "🇫🇷", "GB" => "🇬🇧",
      "GE" => "🇬🇪", "GI" => "🇬🇮", "GR" => "🇬🇷", "HU" => "🇭🇺", "IE" => "🇮🇪",
      "IS" => "🇮🇸", "IT" => "🇮🇹", "LT" => "🇱🇹", "LU" => "🇱🇺", "LV" => "🇱🇻",
      "NO" => "🇳🇴", "NL" => "🇳🇱", "PL" => "🇵🇱", "PT" => "🇵🇹",
      "RO" => "🇷🇴", "SE" => "🇸🇪", "SI" => "🇸🇮", "SK" => "🇸🇰", "TR" => "🇹🇷",
      "UA" => "🇺🇦",
      "PO" => "🇵🇹"
    }

    flags[nationality_code]
  end

  def active_link?(path)
    current_page?(path) ? 'active' : ''
  end

  # Helper for language switching
  def language_switcher
    available_locales = I18n.available_locales.map(&:to_s)
    current_locale = I18n.locale.to_s

    available_locales.reject { |locale| locale == current_locale }.map do |locale|
      link_to t("locales.#{locale}", locale: locale), change_locale_path(locale: locale), class: 'language-link'
    end.join(' | ').html_safe
  end

end
