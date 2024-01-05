
10.times do |n|
  # User for Organisateur
  user = User.create!(email: "organizer#{n}@example.com", password: "password", password_confirmation: "password")

  # Organisateur
  organisateur = Organisateur.create!(user_id: user.id, nom_organisme: "Music Academy #{n}", description_organisme: "Dedicated to nurturing musical talents #{n}")

  # Organism
  organism = Organism.create!(organisateur_id: organisateur.id, nom: "International Music Competition #{n}", description: "Annual music competition for young talents #{n}")

  # Competition
  competition = Competition.create!(organism_id: organism.id, nom_concours: "Young Musicians #{n}", description: "A platform for young musicians to showcase their skills #{n}")

  # EditionCompetition
  edition = EditionCompetition.create!(competition_id: competition.id, annee: 2024 + n, details_specifiques: "Special edition focusing on classical music #{n}", end_of_registration: Date.today + 30, start_date: Date.today + 60, end_date: Date.today + 90)
  # Add Address to EditionCompetition
  edition.address = Address.create!(addressable_id: edition.id, addressable_type: "EditionCompetition", line1: "Rue de la Paix #{n}", city: "Paris #{n}", country: "France #{n}", zipcode: "75000 #{n}")
  # Categories
  category1 = Category.create!(edition_competition_id: edition.id, name: "Piano under 18 #{n}", description: "Category for participants under 18 years #{n}", min_age: 10, max_age: 18, discipline: 1)
  category2 = Category.create!(edition_competition_id: edition.id, name: "Piano under 12 #{n}", description: "Category for children under 12 years #{n}", min_age: 6, max_age: 12, discipline: 2)

  # Tours for Category1
  Tour.create!(category_id: category1.id, start_date: Date.today, start_time: Time.now, end_date: Date.today + 30, end_time: Time.now + 6.hours, is_online: false, title: "Preliminary Round #{n}", description: "First round of the competition #{n}")
  Tour.create!(category_id: category1.id, start_date: Date.today + 60, start_time: Time.now, end_date: Date.today + 90, end_time: Time.now + 6.hours, is_online: true, title: "Online Round #{n}", description: "Second round, conducted online #{n}")

  # Tours for Category2
  Tour.create!(category_id: category2.id, start_date: Date.today, start_time: Time.now, end_date: Date.today + 20, end_time: Time.now + 5.hours, is_online: false, title: "First Round #{n}", description: "Opening round for category #{n}")
  Tour.create!(category_id: category2.id, start_date: Date.today + 25, start_time: Time.now, end_date: Date.today + 45, end_time: Time.now + 5.hours, is_online: true, title: "Virtual Showcase #{n}", description: "Virtual performance round #{n}")
  Tour.create!(category_id: category2.id, start_date: Date.today + 50, start_time: Time.now, end_date: Date.today + 70, end_time: Time.now + 5.hours, is_online: false, title: "Semi Finals #{n}", description: "Semi-final round of performances #{n}")
  Tour.create!(category_id: category2.id, start_date: Date.today + 75, start_time: Time.now, end_date: Date.today + 95, end_time: Time.now + 5.hours, is_online: false, title: "Grand Finale #{n}", description: "Final round for the top performers #{n}")

  # Users for Candidats
  candidate_user1 = User.create!(email: "candidate1_#{n}@example.com", password: "password123", password_confirmation: "password123")
  candidate_user2 = User.create!(email: "candidate2_#{n}@example.com", password: "password123", password_confirmation: "password123")

  # Candidats
  Candidat.create!(user_id: candidate_user1.id, cv: "Link to CV of candidate 1 - #{n}", bio: "Short bio of candidate 1 - #{n}")
  Candidat.create!(user_id: candidate_user2.id, cv: "Link to CV of candidate 2 - #{n}", bio: "Short bio of candidate 2 - #{n}")

  # RequirementItems for Category1
  3.times do |i|
    RequirementItem.create!(category_id: category1.id, type_item: 'filePDF', title: "Lettre de recommandation #{i + 1} - #{n}", description_item: "Une lettre de recommandation au format PDF - #{n}.")
  end

  RequirementItem.create!(category_id: category1.id, type_item: 'filePDF', title: "Certificat d'autorisation parentale - #{n}", description_item: "Certificat d’autorisation parentale au format PDF - #{n}.")
  RequirementItem.create!(category_id: category1.id, type_item: 'lienvideo', title: "Enregistrement vidéo - Air d'opéra en français - #{n}", description_item: "Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes - #{n}. L'air d'opéra doit être en français. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.")
  RequirementItem.create!(category_id: category1.id, type_item: 'lienvideo', title: "Enregistrement vidéo - Lied en allemand - #{n}", description_item: "Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes - #{n}. Le lied doit être en allemand. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.")

  # Create ImposedWork, ChoiceImposedWork, and SemiImposedWork
  imposed_work = ImposedWork.create!(
  category_id: category1.id,
  title: "Oeuvre imposées - Baroque #{n}",
  guidelines: "All pieces must be performed from memory without sheet music."
  )

  choice_imposed_work = ChoiceImposedWork.create!(
    category_id: category1.id,
    title: "Baroque Selections #{n}",
    guidelines: "Choose any two Baroque era compositions.",
    number_to_select: 2
  )

  semi_imposed_work = SemiImposedWork.create!(
    category_id: category1.id,
    title: "Romantic Selections #{n}",
    guidelines: "Any work from prominent Romantic composers.",
    number: 2,
    max_length_minutes: 10
  )

  # Create and associate Airs with each work
  7.times do |m|
    air = Air.create!(
      title: "Air #{m} - #{n}",
      length_minutes: m+3,
      composer: "Composer #{m}",
      oeuvre: "Oeuvre #{m}",
      character: "Character #{m}",
      tonality: "#{['C', 'D', 'E', 'F', 'G', 'A', 'B'][m]} Major"
    )

    # Associate Airs with the corresponding work based on a condition
    if m < 2
      air.update(imposed_work_id: imposed_work.id)
    elsif m < 4
      air.update(choice_imposed_work_id: choice_imposed_work.id)
    else
      air.update(semi_imposed_work_id: semi_imposed_work.id)
    end
  end
end

User.create(email: "candidat@musicast.fr", password: "password", password_confirmation: "password")
