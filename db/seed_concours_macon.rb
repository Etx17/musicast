# creating User
u = User.create(
  email: "macon@musikast.com",
  password: 'password',
  password_confirmation: 'password',
  inscription_role: 'organiser',
  accepted_terms: true
)

# Creating organism
o = Organism.create(
  organisateur: u.organisateur,
  nom: "Les Symphonies D'automne Macon",
  description: "Les Symphonies D'automne Macon est une association qui organise le Concours international de chant de Mâcon, édition 2025, du 10 au 16 novembre 2025. Le concours est ouvert aux jeunes chanteurs de moins de 35 ans (nés après le 1er janvier 1990). Les inscriptions sont ouvertes du 17 mars au 10 septembre 2025. Les récompenses incluent le 1er prix (5 000€), le 2e prix (3 000€), le 3e prix (2 000€), le prix spécial de la mélodie française (3 000€), le prix jeune talent (1 000€), le prix du public (500€), le prix de l'orchestre (500€), et le prix des lycéens. Les finalistes bénéficient d'une indemnité de 250€."
)
file_path = [Rails.root.join('app', 'assets', 'images', 'logo-maitre.png')].sample
file = File.open(file_path, 'rb')
o.logo.attach(
  io: file,
  filename: File.basename(file_path),
  content_type: "image/#{File.extname(file_path).delete('.')}"
)
file.close

# Creer pianiste accompagnateur sur organisme
PianistAccompagnateur.create(
  organism: o,
  full_name: "Jean Dechambre",
  email: Faker::Internet.email,
  phone_number: "0768736635"
)

PianistAccompagnateur.create(
  organism: o,
  full_name: "Olivier Chauvet",
  email: Faker::Internet.email,
  phone_number: "0748733635"
)

# Creating competition
c = Competition.create(
  organism: o,
  nom_concours: "Concours international de chant de Mâcon",
  description: "Concours international de chant de Mâcon, édition 2025, du 10 au 16 novembre 2025. Ouvert aux jeunes chanteurs de moins de 35 ans (nés après le 1er janvier 1990). Inscriptions du 17 mars au 10 septembre 2025. Récompenses : 1er prix (5 000€), 2e prix (3 000€), 3e prix (2 000€), prix spécial de la mélodie française (3 000€), prix jeune talent (1 000€), prix du public (500€), prix de l'orchestre (500€), prix des lycéens. Indemnité de 250€ pour les finalistes."
)

# Creating Edition Competition
ec = EditionCompetition.create(
  competition: c,
  annee: 2025,
  status: "draft",
  start_date: Date.new(2025, 11, 10),
  end_date: Date.new(2025, 11, 16),
  end_of_registration: Date.new(2025, 9, 10),
  reglement_url: "https://www.calameo.com/read/007183595dac5551a87f4",
  details_specifiques: "Édition 2025 du Concours international de chant de Mâcon.",
  specific_details_english: "2025 edition of the Mâcon International Singing Competition."
)
Address.create(
  addressable: ec,
  line1: "Théâtre, Scène nationale de Mâcon",
  city: "Mâcon",
  zipcode: "71000",
  country: "France"
)

# Creating Category
categ = Category.create(
  edition_competition: ec,
  name: "Concours international de chant de Mâcon",
  description: "Concours international de chant de Mâcon, édition 2025, du 10 au 16 novembre 2025. Ouvert aux jeunes chanteurs de moins de 35 ans (nés après le 1er janvier 1990). Inscriptions du 17 mars au 10 septembre 2025. Récompenses : 1er prix (5 000€), 2e prix (3 000€), 3e prix (2 000€), prix spécial de la mélodie française (3 000€), prix jeune talent (1 000€), prix du public (500€), prix de l'orchestre (500€), prix des lycéens. Indemnité de 250€ pour les finalistes.",
  min_age: 18,
  max_age: 35,
  discipline: "lyrical_singing",
  price: 60,
  allow_own_pianist_accompagnateur: true,
  payment_after_approval: false
)

ImposedWork.create(
  category: categ,
  title: "Mélodie contemporaine",
  title_english: "Contemporary melody",
  guidelines: "Mélodie contemporaine imposée pour la demi-finale, composée en 2025 par Régis Campo. Les candidats pourront télécharger les références de la partition directement sur le site internet du concours le 1er juin au plus tard.",
  guidelines_english: "Contemporary imposed melody for the semi-finals, composed in 2025 by Régis Campo. Candidates will be able to download the references of the score directly on the competition website by June 1st at the latest.",
  airs: [
      Air.create(
        title: "Mélodie contemporaine",
        composer: "Régis Campo",
        oeuvre: "Mélodie contemporaine",
        length_minutes: 4,
        tonality: "C Major",
        infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
        infos_english: "Additional information about this piece in English. Historical context and performance tips."
      )
    ]
  )

SemiImposedWork.create(
  category: categ,
  title: "Mélodie contemporaine",
  title_english: "Contemporary melody",
  guidelines: "Un air d'opéra et une mélodie française. Le tout ne doit pas dépasser 8 minutes. Les œuvres devront être interprétées sans partitions. Aucune transposition n’est possible.",
  guidelines_english: "1 opera aria and 1 french melody. The total duration must not exceed 8 minutes. The works must be performed without scores. No transposition is possible.",
  number: 2,
  max_length_minutes: 8
)

ChoiceImposedWork.create(
  title: "Liste d'airs d'opéra pour la finale",
  title_english: "List of opera arias for the finals",
  guidelines: "Liste d'airs d'opéra pour la finale",
  guidelines_english: "List of opera arias for the finals",
  number_to_select: 2,
  category: categ,
  airs: [
    Air.create(
      title: "Che gelida manina",
      composer: "Gioachino Rossini",
      character: "Rodolfo",
      fach: "baritone",
      length_minutes: 3,
      tonality: "C Major",
      oeuvre: "La Bohème",
      infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
      infos_english: "Additional information about this piece in English. Historical context and performance tips."
    )
  ]
)

# Creating Tours for the Category
Tour.create!(
  imposed_air_selection: [],
  final_performance_submission_deadline: Date.new(2025, 11, 9),
  tour_number: 1,
  category_id: categ.id,
  start_date: Date.new(2025, 11, 10),
  start_time: Time.new(2025, 11, 10, 9, 0),
  end_date: Date.new(2025, 11, 11),
  end_time: Time.new(2025, 11, 11, 18, 0),
  is_online: false,
  title: "Quarts de finale",
  title_english: "Quarter-finals",
  description: "Premier tour du concours avec sélection par le jury",
  description_english: "First round with jury selection",
  tour_requirement_attributes: {
    description: "Exigences du premier tour: présentation d'un programme varié",
    description_english: "First round requirements: presentation of a varied program",
    min_number_of_works: 1,
    max_number_of_works: 3,
    min_duration_minute: 3,
    max_duration_minute: 9,
    organiser_creates_program: false
  }
)

Tour.create!(
  imposed_air_selection: ["1", "2"],
  final_performance_submission_deadline: Date.new(2025, 11, 12),
  tour_number: 2,
  category_id: categ.id,
  start_date: Date.new(2025, 11, 13),
  start_time: Time.new(2025, 11, 13, 9, 0),
  end_date: Date.new(2025, 11, 14),
  end_time: Time.new(2025, 11, 14, 18, 0),
  is_online: false,
  title: "Demi-finales",
  title_english: "Semi-finals",
  description: "Deuxième tour avec programme imposé par l'organisateur",
  description_english: "Second round with program created by the organizer",
  tour_requirement_attributes: {
    description: "Liste des exigences du second tour: programme créé par l'organisateur",
    description_english: "List of requirements for the second round: program created by the organizer",
    min_number_of_works: 2,
    max_number_of_works: 4,
    min_duration_minute: 4.5,
    max_duration_minute: 12,
    organiser_creates_program: true
  }
)

Tour.create!(
  imposed_air_selection: ["1", "2", "3"],
  final_performance_submission_deadline: Date.new(2025, 11, 15),
  tour_number: 3,
  category_id: categ.id,
  start_date: Date.new(2025, 11, 16),
  start_time: Time.new(2025, 11, 16, 9, 0),
  end_date: Date.new(2025, 11, 16),
  end_time: Time.new(2025, 11, 16, 18, 0),
  is_online: false,
  title: "Finale",
  title_english: "Finals",
  description: "Finale avec accompagnement orchestre",
  description_english: "Finals with orchestra accompaniment",
  tour_requirement_attributes: {
    description: "Exigences de la finale: programme imposé avec accompagnement orchestre",
    description_english: "Finals requirements: imposed program with orchestra accompaniment",
    min_number_of_works: 2,
    max_number_of_works: 4,
    min_duration_minute: 4.5,
    max_duration_minute: 12,
    organiser_creates_program: true
  }
)

# Creating RequirementItem
RequirementItem.create(
  category: categ,
  type_item: "youtube_link",
  title: "Vidéo de vous-même",
  description_item: "Veuillez fournir un lien vers une vidéo de présentation de vous-même ou vous interprêtez un air.",
  description_item_english: "Please provide a link to a video of yourself performing an aria."
)

SemiImposedWork.create(
  category: categ,
  title: "1 air et 1 mélodie",
  title_english: "1 aria and 1 melody",
  guidelines: "1 air d'opéra, d'operette ou d'oratorio et 1 mélodie. L'un des deux doit impérativement être en français. Le tout ne doit pas dépasser 8 minutes",
  guidelines_english: "1 opera aria, operetta or oratorio and 1 melody. One of the two must be in French. The total duration must not exceed 8 minutes",
  number: 2,
  max_length_minutes: 8
)

# Create prizes for the category
Prize.create!(
  category_id: categ.id,
  title: "1er prix",
  title_english: "1st Prize",
  amount: 5000,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du 1er prix recevra une récompense de 5 000€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The 1st Prize winner will receive a cash award of 5,000€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "2e prix",
  title_english: "2nd Prize",
  amount: 3000,
  other_reward: "Masterclass avec un artiste renommé",
  other_reward_english: "Masterclass with a renowned artist",
  description: "Le lauréat du 2e prix recevra une récompense de 3 000€ et participera à une masterclass exclusive.",
  description_english: "The 2nd Prize winner will receive a cash award of 3,000€ and will participate in an exclusive masterclass."
)

Prize.create!(
  category_id: categ.id,
  title: "3e prix",
  title_english: "3rd Prize",
  amount: 2000,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du 3e prix recevra une récompense de 2 000€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The 3rd Prize winner will receive a cash award of 2,000€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix spécial de la mélodie française",
  title_english: "Special French Melody Prize",
  amount: 3000,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du prix spécial de la mélodie française recevra une récompense de 3 000€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The Special French Melody Prize winner will receive a cash award of 3,000€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix jeune talent",
  title_english: "Young Talent Prize",
  amount: 1000,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du prix jeune talent recevra une récompense de 1 000€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The Young Talent Prize winner will receive a cash award of 1,000€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix du public",
  title_english: "Audience Prize",
  amount: 500,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du prix du public recevra une récompense de 500€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The Audience Prize winner will receive a cash award of 500€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix de l'orchestre",
  title_english: "Orchestra Prize",
  amount: 500,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du prix de l'orchestre recevra une récompense de 500€ et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The Orchestra Prize winner will receive a cash award of 500€ and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix des lycéens",
  title_english: "High School Prize",
  amount: 0,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du prix des lycéens recevra l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The High School Prize winner will receive the opportunity to perform at a concert at the Ecole Normale de Musique."
)


# Seeder les candidats performances
20.times do
  u = User.create(
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    inscription_role: 'candidate',
    accepted_terms: true
  )
  u.candidat.update(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 35),
    nationality: "FR",
    short_bio: Faker::Lorem.paragraph(sentence_count: 2),
    medium_bio: Faker::Lorem.paragraph(sentence_count: 5),
    long_bio: Faker::Lorem.paragraph(sentence_count: 10),
    repertoire: Faker::Lorem.paragraph(sentence_count: 5),
    short_bio_en: Faker::Lorem.paragraph(sentence_count: 2),
    medium_bio_en: Faker::Lorem.paragraph(sentence_count: 5),
    long_bio_en: Faker::Lorem.paragraph(sentence_count: 10),
  )
  i=Inscription.new(
    category: categ,
    status: 'in_review',
    candidat: u.candidat,
    terms_accepted: true
  )
  i.save(validate: false)

  j=InscriptionItemRequirement.new(
    inscription_id: i.id,
    requirement_item: categ.requirement_items.find_by(type_item: "youtube_link"),
    submitted_content: "https://www.youtube.com/watch?v=FrxSZCLbhSQ"
  )
  j.save(validate: false)

  # Create airs with English info
  air1 = Air.create!(
    title: Faker::Music::Opera.send([:rossini, :verdi, :donizetti, :bellini, :mozart].sample),
    length_minutes: rand(3..7),
    composer: ["Verdi", "Mozart", "Puccini", "Bizet", "Rossini"].sample,
    oeuvre: ["La Traviata", "Don Giovanni", "Carmen", "La Bohème", "Le Barbier de Séville"].sample,
    character: ["Violetta", "Don Giovanni", "Carmen", "Rodolfo", "Figaro"].sample,
    tonality: ["C Major", "D Minor", "G Major", "A Minor", "F Major"].sample,
    infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
    infos_english: "Additional information about this piece in English. Historical context and performance tips."
  )

  air2 = Air.create!(
    title: Faker::Music::Opera.send([:rossini, :verdi, :donizetti, :bellini, :mozart].sample),
    length_minutes: rand(3..7),
    composer: ["Verdi", "Mozart", "Puccini", "Bizet", "Rossini"].sample,
    oeuvre: ["La Traviata", "Don Giovanni", "Carmen", "La Bohème", "Le Barbier de Séville"].sample,
    character: ["Violetta", "Don Giovanni", "Carmen", "Rodolfo", "Figaro"].sample,
    tonality: ["C Major", "D Minor", "G Major", "A Minor", "F Major"].sample,
    infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
    infos_english: "Additional information about this piece in English. Historical context and performance tips."
  )

  SemiImposedWorkAir.create(
    inscription: i,
    air: air1,
    semi_imposed_work: categ.semi_imposed_works.first
  )
  SemiImposedWorkAir.create(
    inscription: i,
    air: air2,
    semi_imposed_work: categ.semi_imposed_works.first
  )
  Performance.create(
    inscription: i,
    tour: categ.tours.first,
    air_selection: [air1.id, air2.id],
    ordered_air_selection: [air1.id, air2.id]
  )

  file_path = [Rails.root.join('app', 'assets', 'images', 'john.jpeg'), Rails.root.join('app', 'assets', 'images', 'paul.jpg')].sample
  file = File.open(file_path, 'rb')
  p "Attaching portrait"
  u.candidat.portrait.attach(
    io: file,
    filename: File.basename(file_path),
    content_type: "image/#{File.extname(file_path).delete('.')}"
  )
  p "saving candidat"
  file.close
end

# Assigner les tessitures
voice_types = Candidat.voice_types.keys - ["non_singer"]
candidates = Candidat.all.shuffle
voice_cycle = voice_types.cycle
current_voice = voice_cycle.next
candidates.each do |candidate|
  candidate.update(voice_type: current_voice)
  current_voice = voice_cycle.next
end
