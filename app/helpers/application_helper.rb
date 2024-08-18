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

end
