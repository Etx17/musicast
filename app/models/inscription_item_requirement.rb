class InscriptionItemRequirement < ApplicationRecord
  belongs_to :inscription
  belongs_to :requirement_item

  has_one_attached :submitted_file

  enum verification_status: { not_checked_yet: 0, checked_valid: 1, checked_invalid: 2, ai_failed: 3, not_sure: 4, no_need_to_check: 5 }

  def status_text
    case verification_status
    when "not_checked_yet"
      "Pas encore vérifié"
    when "checked_valid"
      "✅ Validé"
    when "checked_invalid"
      "Invalide"
    when "ai_failed"
      "Erreur AI"
    when "not_sure"
      "Pas sûr"
    when "no_need_to_check"
      "Pas de vérification nécessaire"
    end
  end

  def status_color
    case verification_status
    when "not_checked_yet"
      "secondary"
    when "checked_valid"
      "success"
    when "checked_invalid"
      "red"
    when "ai_failed"
      "warning"
    when "not_sure"
      "info"
    when "no_need_to_check"
      "secondary"
    end
  end

  def submitted_file_changed?
    attachment_changes['submitted_file'].present?
  end

  def extract_pdf_content
    if requirement_item.is_pdf?
      content = submitted_file.download
      reader = PDF::Reader.new(StringIO.new(content))
      text = reader.pages.map(&:text).join(" ").gsub(/\s+/, ' ')
      text[0..500]
    end
  end

  def send_to_openai
    if !requirement_item.is_pdf?
      self.verification_status.no_need_to_check!
      return
    end
    text = extract_pdf_content
    api_key = Rails.application.credentials.dig(:open_ai, :test_key)
    if text
      client = OpenAI::Client.new
      response = client.chat(parameters: {
        model: "gpt-4",
        messages: [{ role: "user", content:"Tu ne répond que par '0'( = non), '1' (= oui), ou '2' (= je sais pas). Voici le début d'un document. Répond simplement '1' si le document te semble être un authorisation_parental , '0' si ca n'est pas le cas, '2' si tu ne sais pas. Tu ne réponds pas par une phrase, seulement un numéro.Voici l'extrait: " + text}]
      })

      if response["choices"][0]["message"]["content"] == "1"
        # Do something if file correspond to what's expected, like maybe update it to checked ai to checked.
        self.verification_status.checked_valid!
      elsif response["choices"][0]["message"]["content"] == "0"
        # Update to not checked
        self.verification_status.checked_invalid!
      elsif response["choices"][0]["message"]["content"] == "2"
        # update to "not sure"
        self.verification_status.not_sure!
      else
        self.verification_status.ai_failed!
      end
    end
  end

end
