class ConvocationMailer < ApplicationMailer
  def convocation_email(candidat, tour, organism, competition, edition_competition, category, config = {})
    @candidat = candidat
    @tour = tour
    @organism = organism
    @competition = competition
    @edition_competition = edition_competition
    @category = category
    @config = config

    mail(
      to: candidat.email,
      subject: "Convocation - #{@config[:competition_name] || 'Concours'}"
    )
  end
end
