class ConvocationMailer < ApplicationMailer
  def convocation_email(candidat, inscription, tour, category, competition, organism, convocation_config)
    @candidat = candidat
    @inscription = inscription
    @tour = tour
    @category = category
    @competition = competition
    @organism = organism
    @convocation_config = convocation_config

    # Données d'exemple pour la prévisualisation
    @sample_data = {
      candidat: {
        nom: "Sophie Martin",
        prenom: "Sophie"
      },
      concours: {
        nom: competition.nom_concours,
        nom_en: competition.nom_concours_en || competition.nom_concours
      },
      tour: {
        nom: tour.nom,
        nom_en: tour.nom_en || tour.nom
      },
      performance: {
        date: "15 janvier 2024",
        date_en: "January 15, 2024",
        heure: "14h30",
        heure_en: "2:30 PM",
        lieu: "Conservatoire de Lyon, Salle Berlioz\n14 rue du Conservatoire, 69002 Lyon",
        lieu_en: "Lyon Conservatory, Berlioz Hall\n14 rue du Conservatoire, 69002 Lyon"
      },
      programme: [
        { titre: "Nessun dorma", compositeur: "Giacomo Puccini", duree: "3 min" },
        { titre: "O mio babbino caro", compositeur: "Giacomo Puccini", duree: "2 min" },
        { titre: "Ave Maria", compositeur: "Franz Schubert", duree: "4 min" }
      ],
      pianiste: {
        nom: "Jean Dubois",
        fourni_organisme: true
      },
      repetition: {
        heure: "13h00",
        heure_en: "1:00 PM",
        lieu: "Salle de répétition A",
        lieu_en: "Rehearsal Room A"
      }
    }

    mail(
      to: candidat&.email || "preview@example.com",
      subject: "Convocation - #{competition.nom_concours} - #{tour.nom}"
    )
  end
end
