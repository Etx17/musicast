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
  description: "L’association Les Maîtres du Chant dont la présidence est assurée par Sylvie SULLÉ, artiste lyrique et professeure de chant à l’Ecole Normale de Musique-Alfred CORTOT, aide à la promotion de jeunes chanteurs-ses en organisant des concours de niveaux différents : « Honneur » pour les chanteurs en cours d’étude et Grands amateurs et « Excellence » pour les chanteurs en début de carrière. Les Maîtres du Chant organisent également un concours d’opérette et d’opéra-comique."
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
  nom_concours: "Concours Les Maîtres du Chant",
  description: "Concours de chant pour les chanteurs en cours d'étude et les grands amateurs.",
)

# Creating Edition Competition
ec = EditionCompetition.create(
  competition: c,
  annee: 2024,
  status: "draft",
  start_date: "2024-03-24",
  end_date: "2024-03-24",
  end_of_registration: "2024-03-09",
  reglement_url: "https://lesmaitresduchant.com/reglement/"
)
Address.create(
  addressable: ec,
  line1: "Ecole Normale de Musique Alfred Cortot",
  city: "Paris",
  zipcode: "75017",
  country: "FR"
)

# Creating Category
categ = Category.create(
  edition_competition: ec,
  name: "Honneur2",
  description: "Le Concours d’Honneur des Maîtres du Chant est un concours public.",
  min_age: 18,
  max_age: 40,
  discipline: "lyrical_singing",
  price: 60,
  allow_own_pianist_accompagnateur: true,
  preselection_vote_type: "hundred_points"
)

# Creating RequirementItem
reqitem = RequirementItem.create(
  category: categ,
  type_item: "youtube_link",
  title: "Vidéo de vous-même",
  description_item: "Veuillez fournir un lien vers une vidéo de présentation de vous-même ou vous interprêtez un air.",
)

SemiImposedWork.create(
  category: categ,
  title: "1 air et 1 mélodie",
  guidelines: "1 air d'opéra, d'operette ou d'oratorio et 1 mélodie. L'un des deux doit impérativement être en français. Le tout ne doit pas dépasser 8 minutes",
  number:2,
  max_length_minutes: 8
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
# Seeder categories_juries


# Seeder les candidats performances
# 6.times do
#   u = User.create(
#     email: Faker::Internet.email,
#     password: 'password',
#     password_confirmation: 'password',
#     inscription_role: 'candidate',
#     accepted_terms: true
#   )
#   u.candidat.update(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
#     nationality: "FR",
#     short_bio: Faker::Lorem.paragraph(sentence_count: 2),
#     medium_bio: Faker::Lorem.paragraph(sentence_count: 5),
#     long_bio: Faker::Lorem.paragraph(sentence_count: 10),
#     repertoire: Faker::Lorem.paragraph(sentence_count: 5),
#     short_bio_en: Faker::Lorem.paragraph(sentence_count: 2),
#     medium_bio_en: Faker::Lorem.paragraph(sentence_count: 5),
#     long_bio_en: Faker::Lorem.paragraph(sentence_count: 10),
#   )
#   i=Inscription.create(
#     category: categ,
#     status: 'in_review',
#     candidat: u.candidat,
#     terms_accepted: true
#   )

#   InscriptionItemRequirement.create(
#     inscription: i,
#     requirement_item: categ.requirement_items.find_by(type_item: "youtube_link"),
#     submitted_content: "https://www.youtube.com/watch?v=FrxSZCLbhSQ"
#   )

#   air1 = Air.all.sample
#   air2 = Air.all.sample
#   SemiImposedWorkAir.create(
#     inscription: i,
#     air: air1,
#     semi_imposed_work: categ.semi_imposed_works.first
#   )
#   SemiImposedWorkAir.create(
#     inscription: i,
#     air: air2,
#     semi_imposed_work: categ.semi_imposed_works.first
#   )
#   Performance.create(
#     inscription: i,
#     tour: categ.tours.first,
#     air_selection: [air1.id, air2.id],
#     ordered_air_selection: [air1.id, air2.id]
#   )

#   file_path = [Rails.root.join('app', 'assets', 'images', 'john.jpeg'), Rails.root.join('app', 'assets', 'images', 'paul.jpg'), Rails.root.join('app', 'assets', 'images', 'profile.jpeg')].sample
#   file = File.open(file_path, 'rb')
#   p "Attaching portrait"
#   u.candidat.portrait.attach(
#     io: file,
#     filename: File.basename(file_path),
#     content_type: "image/#{File.extname(file_path).delete('.')}"
#   )
#   p"saving candidat"
#   file.close

# end
