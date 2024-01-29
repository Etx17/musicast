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
      OpenAI::API.new.create_completion(
        engine: "text-davinci-002",
        prompt: "Tu ne répond que par '0'( = non), '1' (= oui), ou '2' (= je sais pas). Voici le début d'un document. Répond simplement '1' si le document te semble être un #{requirement_item.item_type} , '0' si ca n'est pas le cas, '2' si tu ne sais pas. Tu ne réponds pas par une phrase, seulement un numéro.Voici l'extrait: " + text,
        max_tokens: 200,
        headers: {
          'Authorization' => "Bearer #{Rails.application.credentials.dig(:open_ai, :test_key)}"
        }
      )
    end
  end

end
