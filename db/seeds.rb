
10.times do |n|

  u = User.create(email: "candidat#{n}@example.com", password: "password", password_confirmation: "password")

  unless n == 0
    c = Candidat.create!(short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce", user_id: u.id, cv: "Link to CV of candidate ", bio: "Short bio of candidate ")
  end
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
  edition.address = Address.create!(addressable_id: edition.id, addressable_type: "EditionCompetition", line1: "Rue de la Paix #{n}", city: "Paris", country: "France", zipcode: "75000")
  # Categories
  category1 = Category.create!( price: 100, edition_competition_id: edition.id, name: "Opera under 18 #{n}", description: "Category for participants under 18 years #{n}", min_age: 10, max_age: 18, discipline: "lyrical_singing")
  category2 = Category.create!(price: 50, edition_competition_id: edition.id, name: "Piano under 12 #{n}", description: "Category for children under 12 years #{n}", min_age: 6, max_age: 12, discipline: 2)

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
    final_performance_submission_deadline: Date.today + 29, tour_number: 1, category_id: category1.id, start_date: Date.today + 30, start_time: Time.now, end_date: Date.today + 32, end_time: Time.now + 6.hours, is_online: false, title: "Tour éliminatoire", description: "First round of the competition #{n}", tour_requirement_attributes: { description: "Preliminary round requirements", min_number_of_works: 1, max_number_of_works: 3, min_duration_minute: 3, max_duration_minute: 9, organiser_creates_program: false } )
  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 55, tour_number: 2, category_id: category1.id, start_date: Date.today + 60, start_time: Time.now, end_date: Date.today + 90, end_time: Time.now + 6.hours, is_online: true, title: "Demi finale", description: "Second round, conducted online #{n}", tour_requirement_attributes: { description: "Online round requirements", min_number_of_works: 2, max_number_of_works: 4, min_duration_minute: 4.5, max_duration_minute: 12, organiser_creates_program: true } )
  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 89, tour_number: 3, category_id: category1.id, start_date: Date.today + 120, start_time: Time.now, end_date: Date.today + 150, end_time: Time.now + 6.hours, is_online: false, title: "Finale", description: "Final round of the competition #{n}", tour_requirement_attributes: { description: "Final round requirements. Candidat must be wearing black suit or dress. NO partition allowed.", min_number_of_works: 2, max_number_of_works: 4, min_duration_minute: 4.5, max_duration_minute: 12, organiser_creates_program: false } )
  # Tours for Category2
  Tour.create!(
    imposed_air_selection: [],
    final_performance_submission_deadline: Date.today + 29, tour_number: 1, category_id: category2.id, start_date: Date.today + 30, start_time: Time.now, end_date: Date.today + 32, end_time: Time.now + 6.hours, is_online: false, title: "Tour éliminatoire", description: "First round of the competition #{n}", tour_requirement_attributes: { description: "Preliminary round requirements", min_number_of_works: 1, max_number_of_works: 3, min_duration_minute: 3, max_duration_minute: 9, organiser_creates_program: false } )
  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 59, tour_number: 2, category_id: category2.id, start_date: Date.today + 60, start_time: Time.now, end_date: Date.today + 90, end_time: Time.now + 6.hours, is_online: true, title: "Demi finale", description: "Second round, conducted online #{n}", tour_requirement_attributes: { description: "Online round requirements", min_number_of_works: 2, max_number_of_works: 4, min_duration_minute: 4.5, max_duration_minute: 12, organiser_creates_program: true } )
  Tour.create!(
    imposed_air_selection: ["1", "2"],
    final_performance_submission_deadline: Date.today + 89, tour_number: 3, category_id: category2.id, start_date: Date.today + 120, start_time: Time.now, end_date: Date.today + 150, end_time: Time.now + 6.hours, is_online: false, title: "Finale", description: "Final round of the competition #{n}", tour_requirement_attributes: { description: "Final round requirements. Candidat must be wearing black suit or dress. NO partition allowed.", min_number_of_works: 2, max_number_of_works: 4, min_duration_minute: 4.5, max_duration_minute: 12, organiser_creates_program: false } )
  # Users for Candidats
  candidate_user1 = User.create!(email: "candidate1_#{n}@example.com", password: "password123", password_confirmation: "password123")
  candidate_user2 = User.create!(email: "candidate2_#{n}@example.com", password: "password123", password_confirmation: "password123")

  # Candidats
  Candidat.create!(short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce",user_id: candidate_user1.id, cv: "Link to CV of candidate 1 - #{n}", bio: "Short bio of candidate 1 - #{n}")
  Candidat.create!(short_bio: "Coucou, je suis un chanteur lyrique", medium_bio: "Après avoir passé 2 ans a l'école de Bruxelles en chant lyrique, je me suis spécialisé dans le répertoire baroque. blablablablababla", long_bio: "In this code, check_image_ratio is a custom validation method that checks if the uploaded image has the correct aspect ratio. If the image does not have the correct ratio, it is deleted and an error is added to the image attribute. Please note that this code requires the active_storage gem and assumes that you have set up Active Storage and attached an image to the Candidat model. Also, you should replace 4.0 / 3.0 with the aspect ratio you want to enforce",user_id: candidate_user2.id, cv: "Link to CV of candidate 2 - #{n}", bio: "Short bio of candidate 2 - #{n}")

  # RequirementItems for Category1
  RequirementItem.create!(category_id: category1.id, type_item: 'recommendation_letter', title: "Lettre de recommandation - #{n}", description_item: "Une lettre de recommandation au format PDF - #{n}.")
  RequirementItem.create!(category_id: category1.id, type_item: 'parental_authorization', title: "Certificat d'autorisation parentale - #{n}", description_item: "Certificat d’autorisation parentale au format PDF - #{n}.")
  RequirementItem.create!(category_id: category1.id, type_item: 'motivation_essay', title: "Lettre de motivation n°#{n}", description_item: "Lettre de motivation du candidat présentant sa volonté de participer")
  RequirementItem.create!(category_id: category1.id, type_item: 'youtube_link', title: "Enregistrement vidéo - Lied en allemand - #{n}", description_item: "Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes - #{n}. Le lied doit être en allemand. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.")
  # { youtube_link: 0, recommendation_letter: 1, parental_authorization: 2, motivation_essay: 3 }
  # Create ImposedWork, ChoiceImposedWork, and SemiImposedWork
  imposed_work = ImposedWork.create!(
  category_id: category1.id,
  title: "Oeuvre imposées - Baroque",
  guidelines: "All pieces must be performed from memory without sheet music."
  )

  choice_imposed_work = ChoiceImposedWork.create!(
    category_id: category1.id,
    title: "Operatic Selections",
    guidelines: "Choose any two Opera pieces",
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
    methods = [:rossini, :verdi, :donizetti, :bellini, :mozart]

    air = Air.create!(
      title: Faker::Music::Opera.send(methods.sample),
      length_minutes: m+3,
      composer: methods.sample.to_s,
      oeuvre: "Oeuvre complête II",
      character: "Fidelo",
      tonality: "#{['C', 'D', 'E', 'F', 'G', 'A', 'B'][m]} Major"
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

end

category = Category.first
tour = category.tours.first

Candidat.all.each do |candidat|
  candidat.update(first_name: Faker::Name.first_name)
  inscription = Inscription.create!(candidat_id: candidat.id, category_id: category.id, status: 'in_review')
  # Performance.create!(inscription: inscription, tour: tour, air_selection: ["1", "2", "3", "4"])
end

#Create new Jury for each Organism existing
Organism.all.each do |organism|
  user = User.create!(email: Faker::Internet.email, password: "password123", password_confirmation: "password123", inscription_role: "jury")
  Jury.create(user: user, email: user.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
end
