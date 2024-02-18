# creating User
u = User.create(
  email: "niceconcours@musikast.com",
  password: 'password',
  password_confirmation: 'password',
  inscription_role: 'organiser',
  accepted_terms: true
)


# Creating organism
o = Organism.create(
  organisateur: u.organisateur,
  nom: "Nice Concours International",
  description: "Concours International de Piano, Piano solo, Piano à 4 mains, Piano avec orchestre symphonique, Jeunes talents."
)
# file_path = [Rails.root.join('app', 'assets', 'images', 'logo-nice.png')].sample
# file = File.open(file_path, 'rb')
# o.logo.attach(
#   io: file,
#   filename: File.basename(file_path),
#   content_type: "image/#{File.extname(file_path).delete('.')}"
# )
# file.close

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
  nom_concours: "CONCOURS INTERNATIONAL DE PIANO NICE CÔTE D'AZUR",
  description: "Depuis la création en 2007 du Concours de Piano de Nice, nous nous efforçons d'aider les jeunes talents à se confronter et à s'évaluer au niveau international de la maîtrise de l'art du piano, roi des instruments.
  Notre objectif est de les aider à poursuivre des études et une carrière qui les inspirent. Grâce à nos professeurs passionnés, à nos membres du jury de renom, et à notre personnel exceptionnel, nous espérons œuvrer utilement à une synergie entre émulateurs/pédagogues/professionnels.
  Le Concours International de Piano Nice Côte d'Azur propose une compétition qui favorise l'épanouissement et l'apprentissage des candidats, et qui encourage les esprits créatifs à se dépasser. Parcourez notre site pour découvrir ce que nous avons à offrir.
  Gilbert San Pietro di Monte Rosso,
  Concertiste, Fondateur et Directeur artistique du Concours, Président de l’association « Piano Porta Caeli » organisatrice du concours, Membre du Jury",
)

# Creating Edition Competition
ec = EditionCompetition.create(
  competition: c,
  annee: 2024,
  status: "draft",
  start_date: "2024-03-24",
  end_date: "2024-03-24",
  end_of_registration: "2024-03-09",
  reglement_url: "https://www.concours-international-piano-nice-cote-azur.com/"
)
Address.create(
  addressable: ec,
  line1: "Amphithéâtre du Centre Universitaire Méditerranéen de NICE",
  city: "Nice",
  zipcode: "06000",
  country: "FR"
)

# Creating Category
categ = Category.create(
  edition_competition: ec,
  name: "JEUNE TALENT-Diplôme de Concert",
  description: "Les œuvres contemporaines sont admises à condition qu'elles soient publiées par un éditeur de musique et que les candidats procurent deux exemplaires de la partition aux membres du jury",
  min_age: 5,
  max_age: 24,
  discipline: "piano",
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
  guidelines: "Une œuvre importante de J.S. Bach, et un programme entièrement libre respectant un équilibre entre la virtuosité technique et la sensibilité romantique, d'une part, et un panachage de compositeurs de nationalités et d'époques différentes, d'autre part. Les œuvres contemporaines sont admises à condition qu'elles soient publiées par un éditeur de musique et que les candidats procurent deux exemplaires de la partition aux membres du jury. Durée totale entre 28 et 50 minutes maximum.",
  number: 2,
  max_length_minutes: 50
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
