# creating User
u = User.create(
  email: "lesmaitresduchant@musikast.com",
  password: 'password',
  password_confirmation: 'password',
  inscription_role: 'organiser',
  accepted_terms: true
)

# Creating organism
o = Organism.create(
  organisateur: u.organisateur,
  nom: "Association Les Maîtres du Chant",
  description: "L'association Les Maîtres du Chant dont la présidence est assurée par Sylvie SULLÉ, artiste lyrique et professeure de chant à l'Ecole Normale de Musique-Alfred CORTOT, aide à la promotion de jeunes chanteurs-ses en organisant des concours de niveaux différents : « Honneur » pour les chanteurs en cours d'étude et Grands amateurs et « Excellence » pour les chanteurs en début de carrière. Les Maîtres du Chant organisent également un concours d'opérette et d'opéra-comique."
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
  nom_concours: "Concours d'honneur",
  description: "Concours de chant pour les chanteurs en cours d'étude et les grands amateurs.",
)

# Creating Edition Competition
ec = EditionCompetition.create(
  competition: c,
  annee: 2024,
  status: "draft",
  start_date: Date.today + 1.month,
  end_date: Date.today + 1.month + 3.days,
  end_of_registration: Date.today + 1.month - 1.week,
  reglement_url: "https://lesmaitresduchant.com/reglement/",
  details_specifiques: "Édition spéciale du concours d'honneur avec un focus sur le répertoire français",
  specific_details_english: "Special edition of the Honor Competition with a focus on French repertoire"
)
Address.create(
  addressable: ec,
  line1: "Ecole Normale de Musique Alfred Cortot",
  city: "Paris",
  zipcode: "75017",
  country: "France"
)

# Creating Category
categ = Category.create(
  edition_competition: ec,
  name: "Honneur2",
  description: "Le Concours d'Honneur des Maîtres du Chant est un concours public.",
  min_age: 18,
  max_age: 40,
  discipline: "lyrical_singing",
  price: 60,
  allow_own_pianist_accompagnateur: true,
  preselection_vote_type: "hundred_points"
)

Tour.create!(
  imposed_air_selection: [],
  final_performance_submission_deadline: Date.today + 29,
  tour_number: 1,
  category_id: categ.id,
  start_date: Date.today + 30,
  start_time: Time.now,
  end_date: Date.today + 32,
  end_time: Time.now + 6.hours,
  is_online: false,
  title: "Tour éliminatoire",
  title_english: "Preliminary Round",
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
  final_performance_submission_deadline: Date.today + 55,
  tour_number: 2,
  category_id: categ.id,
  start_date: Date.today + 60,
  start_time: Time.now,
  end_date: Date.today + 90,
  end_time: Time.now + 6.hours,
  is_online: false,
  title: "Demi finale où l'orga crée le programme (config)",
  title_english: "Semi-final where the organizer creates the program (config)",
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

# Creating RequirementItem
reqitem = RequirementItem.create(
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
  title: "Grand Prix d'Honneur",
  title_english: "Grand Honor Prize",
  amount: 3000,
  other_reward: "Concert à l'Ecole Normale de Musique",
  other_reward_english: "Concert at the Ecole Normale de Musique",
  description: "Le lauréat du Grand Prix d'Honneur recevra une récompense en espèces et l'opportunité de se produire lors d'un concert à l'Ecole Normale de Musique.",
  description_english: "The Grand Honor Prize winner will receive a cash award and the opportunity to perform at a concert at the Ecole Normale de Musique."
)

Prize.create!(
  category_id: categ.id,
  title: "Prix du Jury",
  title_english: "Jury Prize",
  amount: 1500,
  other_reward: "Masterclass avec un artiste renommé",
  other_reward_english: "Masterclass with a renowned artist",
  description: "Le lauréat du Prix du Jury recevra une récompense en espèces et participera à une masterclass exclusive.",
  description_english: "The Jury Prize winner will receive a cash award and will participate in an exclusive masterclass."
)

# Seeder juries
i=0
5.times do
  i+=1
  u = User.create(
    email: "jurydeselection#{i}@hotmail.fr",
    password: 'password',
    password_confirmation: 'password',
    inscription_role: 'jury',
    accepted_terms: true
  )
  Jury.create(
    user: u,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: u.email
  )
  OrganismJury.create(
    organism: o,
    jury: u.jury
  )
  CategoriesJury.create(
    category: categ,
    jury: u.jury
  )
end

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
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
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
