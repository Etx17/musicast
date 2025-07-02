class ConvocationMailer < ApplicationMailer
  def convocation_email(performance, config = {})
    @performance = performance
    @candidat = @performance.inscription.candidat
    @tour = @performance.tour
    @category = @tour.category
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @organism = @competition.organism
    @config = config

    mail(
      to: @candidat.email,
      subject: "Convocation - #{@competition.nom_concours} - #{@tour.title}"
    )
  end
end
