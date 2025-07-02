class ConvocationMailer < ApplicationMailer
  def convocation_email(performance, config = {})
    @performance = performance
    @config = config

    @candidat = performance.inscription.candidat
    @tour = performance.tour
    @organism = performance.tour.organism
    @competition = performance.tour.competition
    @edition_competition = performance.tour.edition_competition
    @category = performance.tour.category

    mail(
      to: candidat.email,
      subject: "Convocation - #{@config[:competition_name] || 'Concours'}"
    )
  end
end
