class InscriptionItemRequirement < ApplicationRecord
  belongs_to :inscription
  belongs_to :requirement_item

  has_one_attached :submitted_file


  def extract_pdf_content
    if requirement_item.is_pdf?
      content = submitted_file.download
      reader = PDF::Reader.new(StringIO.new(content))
      text = reader.pages.map(&:text).join(" ").gsub(/\s+/, ' ')
      text[0..500]
    end
  end

  def send_to_openai
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
      elsif response["choices"][0]["message"]["content"] == "0"
        # Update to not checked
      elsif response["choices"][0]["message"]["content"] == "2"
        # update to "not sure"
      else
        # update to "ai failed"
      end
    end
  end

end
