10.times do |n|

  u = User.create(email: "candidat#{n}@example.com", password: "password", password_confirmation: "password")

  unless n == 0
    c = Candidat.create!(last_teacher: Faker::Name.name, short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce", user_id: u.id)
  end
  # User for Organisateur
  user = User.create!(email: "organizer#{n}@example.com", password: "password", password_confirmation: "password")

  # Organisateur
  organisateur = Organisateur.create!(user_id: user.id, nom_organisme: "Académie de Musique #{n}", description_organisme: "Dédié à cultiver les talents musicaux #{n}")

  # Organism
  organism = Organism.create!(organisateur_id: organisateur.id, nom: "Concours International de Musique #{n}", description: "Concours annuel de musique pour jeunes talents #{n}")

  # Competition
  competition = Competition.create!(organism_id: organism.id, nom_concours: "Jeunes Musiciens #{n}", description: "Une plateforme pour les jeunes musiciens pour montrer leurs compétences #{n}")

  # EditionCompetition
  edition = EditionCompetition.create!(
    competition_id: competition.id,
    annee: 2024 + n,
    details_specifiques: "Édition spéciale axée sur la musique classique #{n}",
    specific_details_english: "Special edition focusing on classical music #{n}",
    end_of_registration: Date.today + 30,
    start_date: Date.today + 60,
    end_date: Date.today + 90
  )
  # Add Address to EditionCompetition
  edition.address = Address.create!(addressable_id: edition.id, addressable_type: "EditionCompetition", line1: "Rue de la Paix #{n}", city: "Paris", country: "France", zipcode: "75000")
  # Categories
  category1 = Category.create!( price: 100, edition_competition_id: edition.id, name: "Opéra moins de 18 ans #{n}", description: "Catégorie pour participants de moins de 18 ans #{n}", min_age: 10, max_age: 18, discipline: "lyrical_singing")
  category2 = Category.create!(price: 50, edition_competition_id: edition.id, name: "Piano moins de 12 ans #{n}", description: "Catégorie pour enfants de moins de 12 ans #{n}", min_age: 6, max_age: 12, discipline: 2)

  # Pianistes accompagnateurs de l'organisme
  PianistAccompagnateur.create!(
    email: "pianist_accompagnateur1_#{n}@example.com",
    full_name: Faker::Name.name,
    phone_number: "0147837465",
    organism: organism,
  )

  PianistAccompagnateur.create!(
    email: "pianist_accompagnateur2_#{n}@example.com",
    full_name: Faker::Name.name,
    phone_number: "0147837465",
    organism: organism,
  )

  # Tours for Category1
  Tour.create!(
    imposed_air_selection: [],
    final_performance_submission_deadline: Date.today + 29,
    tour_number: 1,
    category_id: category1.id,
    start_date: Date.today + 30,
    start_time: Time.now,
    end_date: Date.today + 32,
    end_time: Time.now + 6.hours,
    is_online: false,
    title: "Tour éliminatoire",
    title_english: "Preliminary Round",
    description: "Premier tour du concours #{n}",
    description_english: "First round of the competition #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour préliminaire",
      description_english: "Preliminary round requirements",
      min_number_of_works: 1,
      max_number_of_works: 3,
      min_duration_minute: 3,
      max_duration_minute: 9,
      organiser_creates_program: false
    }
  )

  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 55,
    tour_number: 2,
    category_id: category1.id,
    start_date: Date.today + 60,
    start_time: Time.now,
    end_date: Date.today + 90,
    end_time: Time.now + 6.hours,
    is_online: true,
    title: "Demi finale",
    title_english: "Semi-final",
    description: "Deuxième tour, réalisé en ligne #{n}",
    description_english: "Second round, conducted online #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour en ligne",
      description_english: "Online round requirements",
      min_number_of_works: 2,
      max_number_of_works: 4,
      min_duration_minute: 4.5,
      max_duration_minute: 12,
      organiser_creates_program: true
    }
  )

  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 89,
    tour_number: 3,
    category_id: category1.id,
    start_date: Date.today + 120,
    start_time: Time.now,
    end_date: Date.today + 150,
    end_time: Time.now + 6.hours,
    is_online: false,
    title: "Finale",
    title_english: "Final",
    description: "Tour final du concours #{n}",
    description_english: "Final round of the competition #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour final. Le candidat doit porter un costume ou une robe noire. AUCUNE partition autorisée.",
      description_english: "Final round requirements. Candidate must be wearing black suit or dress. NO sheet music allowed.",
      min_number_of_works: 2,
      max_number_of_works: 4,
      min_duration_minute: 4.5,
      max_duration_minute: 12,
      organiser_creates_program: false
    }
  )

  # Tours for Category2
  Tour.create!(
    imposed_air_selection: [],
    final_performance_submission_deadline: Date.today + 29,
    tour_number: 1,
    category_id: category2.id,
    start_date: Date.today + 30,
    start_time: Time.now,
    end_date: Date.today + 32,
    end_time: Time.now + 6.hours,
    is_online: false,
    title: "Tour éliminatoire",
    title_english: "Preliminary Round",
    description: "Premier tour du concours #{n}",
    description_english: "First round of the competition #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour préliminaire",
      description_english: "Preliminary round requirements",
      min_number_of_works: 1,
      max_number_of_works: 3,
      min_duration_minute: 3,
      max_duration_minute: 9,
      organiser_creates_program: false
    }
  )

  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 59,
    tour_number: 2,
    category_id: category2.id,
    start_date: Date.today + 60,
    start_time: Time.now,
    end_date: Date.today + 90,
    end_time: Time.now + 6.hours,
    is_online: true,
    title: "Demi finale",
    title_english: "Semi-final",
    description: "Deuxième tour, réalisé en ligne #{n}",
    description_english: "Second round, conducted online #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour en ligne",
      description_english: "Online round requirements",
      min_number_of_works: 2,
      max_number_of_works: 4,
      min_duration_minute: 4.5,
      max_duration_minute: 12,
      organiser_creates_program: true
    }
  )

  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 89,
    tour_number: 3,
    category_id: category2.id,
    start_date: Date.today + 120,
    start_time: Time.now,
    end_date: Date.today + 150,
    end_time: Time.now + 6.hours,
    is_online: false,
    title: "Finale",
    title_english: "Final",
    description: "Tour final du concours #{n}",
    description_english: "Final round of the competition #{n}",
    tour_requirement_attributes: {
      description: "Exigences du tour final. Le candidat doit porter un costume ou une robe noire. AUCUNE partition autorisée.",
      description_english: "Final round requirements. Candidate must be wearing black suit or dress. NO sheet music allowed.",
      min_number_of_works: 2,
      max_number_of_works: 4,
      min_duration_minute: 4.5,
      max_duration_minute: 12,
      organiser_creates_program: false
    }
  )

  # Users for Candidats
  candidate_user1 = User.create!(email: "candidate1_#{n}@example.com", password: "password123", password_confirmation: "password123")
  candidate_user2 = User.create!(email: "candidate2_#{n}@example.com", password: "password123", password_confirmation: "password123")

  # Candidats
  Candidat.create!(last_teacher: Faker::Name.name, short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce",user_id: candidate_user1.id)
  Candidat.create!(last_teacher: Faker::Name.name, short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce",user_id: candidate_user2.id)

  # RequirementItems for Category1
  RequirementItem.create!(
    category_id: category1.id,
    type_item: 'recommendation_letter',
    title: "Lettre de recommandation - #{n}",
    description_item: "Une lettre de recommandation au format PDF - #{n}.",
    description_item_english: "A recommendation letter in PDF format - #{n}."
  )

  RequirementItem.create!(
    category_id: category1.id,
    type_item: 'parental_authorization',
    title: "Certificat d'autorisation parentale - #{n}",
    description_item: "Certificat d'autorisation parentale au format PDF - #{n}.",
    description_item_english: "Parental authorization certificate in PDF format - #{n}."
  )

  RequirementItem.create!(
    category_id: category1.id,
    type_item: 'motivation_essay',
    title: "Lettre de motivation n°#{n}",
    description_item: "Lettre de motivation du candidat présentant sa volonté de participer",
    description_item_english: "Candidate's motivation letter presenting their willingness to participate"
  )

  RequirementItem.create!(
    category_id: category1.id,
    type_item: 'youtube_link',
    title: "Enregistrement vidéo - Lied en allemand - #{n}",
    description_item: "Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes - #{n}. Le lied doit être en allemand. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.",
    description_item_english: "A good quality video recording, YouTube link, not exceeding 5 minutes - #{n}. The lied must be in German. The pianist's hands must be visible at all times, without any cuts in the video."
  )

  # Create ImposedWork, ChoiceImposedWork, and SemiImposedWork
  imposed_work = ImposedWork.create!(
    category_id: category1.id,
    title: "Œuvres imposées - Baroque",
    title_english: "Required Works - Baroque",
    guidelines: "Toutes les pièces doivent être interprétées par cœur sans partition.",
    guidelines_english: "All pieces must be performed from memory without sheet music."
  )

  choice_imposed_work = ChoiceImposedWork.create!(
    category_id: category1.id,
    title: "Sélections d'opéra",
    title_english: "Operatic Selections",
    guidelines: "Choisissez deux pièces d'opéra",
    guidelines_english: "Choose any two Opera pieces",
    number_to_select: 2
  )

  semi_imposed_work = SemiImposedWork.create!(
    category_id: category1.id,
    title: "Sélections romantiques #{n}",
    title_english: "Romantic Selections #{n}",
    guidelines: "N'importe quelle œuvre de compositeurs romantiques importants.",
    guidelines_english: "Any work from prominent Romantic composers.",
    number: 2,
    max_length_minutes: 10
  )

  # Create and associate Airs with each work
  7.times do |m|
    methods = [:rossini, :verdi, :donizetti, :bellini, :mozart]

    air = Air.create!(
      title: Faker::Music::Opera.send(methods.sample),
      length_minutes: m+3,
      composer: methods.sample.to_s,
      oeuvre: "Œuvre complète II",
      character: "Fidelo",
      tonality: "#{['C', 'D', 'E', 'F', 'G', 'A', 'B'][m]} Major",
      infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
      infos_english: "Additional information about this piece in English. Historical context and performance tips."
    )

    # Associate Airs with the corresponding work based on a condition
    if m < 2
      air.update(imposed_work_id: imposed_work.id, title: "Air imposé Chopin n° #{m}#{n}")
    elsif m < 4
      air.update(choice_imposed_work_id: choice_imposed_work.id)
    else
      air.update(semi_imposed_work_id: semi_imposed_work.id)
    end
  end

  # Create prizes for categories
  Prize.create!(
    category_id: category1.id,
    title: "Premier Prix",
    title_english: "First Prize",
    amount: 5000,
    other_reward: "Concert à la Philharmonie de Paris",
    other_reward_english: "Concert at the Paris Philharmonie",
    description: "Le lauréat du premier prix recevra une récompense en espèces et l'opportunité de se produire lors d'un concert prestigieux.",
    description_english: "The first prize winner will receive a cash award and the opportunity to perform at a prestigious concert."
  )

  Prize.create!(
    category_id: category1.id,
    title: "Deuxième Prix",
    title_english: "Second Prize",
    amount: 3000,
    other_reward: "Masterclass avec un artiste renommé",
    other_reward_english: "Masterclass with a renowned artist",
    description: "Le lauréat du deuxième prix recevra une récompense en espèces et participera à une masterclass exclusive.",
    description_english: "The second prize winner will receive a cash award and will participate in an exclusive masterclass."
  )

  Prize.create!(
    category_id: category2.id,
    title: "Premier Prix Junior",
    title_english: "First Prize Junior",
    amount: 2000,
    other_reward: "Bourse d'études musicales",
    other_reward_english: "Music education scholarship",
    description: "Le lauréat du premier prix junior recevra une bourse pour poursuivre ses études musicales.",
    description_english: "The junior first prize winner will receive a scholarship to pursue their musical studies."
  )
end

category = Category.first
tour = category.tours.first

Candidat.all.each do |candidat|
  candidat.update(first_name: Faker::Name.first_name)
  inscription = Inscription.create!(candidat_id: candidat.id, category_id: category.id, status: 'in_review', terms_accepted: true)
  # Performance.create!(inscription: inscription, tour: tour, air_selection: ["1", "2", "3", "4"])
end

#Create new Jury for each Organism existing
Organism.all.each do |organism|
  user = User.create!(email: Faker::Internet.email, password: "password123", password_confirmation: "password123", inscription_role: "jury")
  Jury.create(user: user, email: user.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end

load Rails.root.join('db', 'seed_concours_honneur.rb')
