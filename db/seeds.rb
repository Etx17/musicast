# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(email: "coucou@gmail.com", password:"password", password_confirmation:"password")

# Create an Organiser
organisateur = Organisateur.create(user_id: 1, nom_organisme: 'Music Academy', description_organisme: 'Dedicated to nurturing musical talents')

# Create an Organism
organism = Organism.create(organisateur: organisateur, nom: 'International Music Competition', description: 'Annual music competition for young talents')

# Create a Competition
competition = Competition.create(organism: organism, nom_concours: 'Young Musicians', description: 'A platform for young musicians to showcase their skills')

# Create an EditionCompetition
edition = EditionCompetition.create(competition: competition, annee: 2023, details_specifiques: 'Special edition focusing on classical music')

# Create Categories
category1 = Category.create(edition_competition: edition, name: 'Piano under 18', description: 'Category for participants under 18 years', min_age: 10, max_age: 18, discipline: 'Piano')
category2 = Category.create(edition_competition: edition, name: 'Piano under 12', description: 'Category for children under 12 years', min_age: 6, max_age: 12, discipline: 'Piano')

# Create Tours for Category1
tour1_cat1 = Tour.create(category: category1, start_date: Date.today, start_time: Time.now, end_date: Date.today + 30, end_time: Time.now + 6.hours, is_online: false, title: 'Preliminary Round', description: 'First round of the competition')
tour2_cat1 = Tour.create(category: category1, start_date: Date.today + 60, start_time: Time.now, end_date: Date.today + 90, end_time: Time.now + 6.hours, is_online: true, title: 'Online Round', description: 'Second round, conducted online')

# Create Tours for Category2
tour1_cat2 = Tour.create(category: category2, start_date: Date.today, start_time: Time.now, end_date: Date.today + 20, end_time: Time.now + 5.hours, is_online: false, title: 'First Round', description: 'Opening round for category')
tour2_cat2 = Tour.create(category: category2, start_date: Date.today + 25, start_time: Time.now, end_date: Date.today + 45, end_time: Time.now + 5.hours, is_online: true, title: 'Virtual Showcase', description: 'Virtual performance round')
tour3_cat2 = Tour.create(category: category2, start_date: Date.today + 50, start_time: Time.now, end_date: Date.today + 70, end_time: Time.now + 5.hours, is_online: false, title: 'Semi Finals', description: 'Semi-final round of performances')
tour4_cat2 = Tour.create(category: category2, start_date: Date.today + 75, start_time: Time.now, end_date: Date.today + 95, end_time: Time.now + 5.hours, is_online: false, title: 'Grand Finale', description: 'Final round for the top performers')


user1 = User.create(email: 'candidate1@example.com', password: 'password123', password_confirmation: 'password123')
user2 = User.create(email: 'candidate2@example.com', password: 'password123', password_confirmation: 'password123')


candidat1 = Candidat.create(user: user1, cv: 'Link to CV of candidate 1', bio: 'Short bio of candidate 1')
candidat2 = Candidat.create(user: user2, cv: 'Link to CV of candidate 2', bio: 'Short bio of candidate 2')


category = Category.find_by(name: 'Piano under 18')


# Create three 'Lettres de Recommendation' as PDF files
3.times do |i|
  RequirementItem.create(
    category: category,
    type_item: 'filePDF',
    title: "Lettre de recommandation ##{i + 1}",
    description_item: 'Une lettre de recommandation au format PDF.'
  )
end

# Create 'Certificat d'Autorisation Parentale' as PDF file
RequirementItem.create(
  category: category,
  type_item: 'filePDF',
  title: 'Certificat d\'autorisation parentale',
  description_item: 'Certificat d’autorisation parentale au format PDF.'
)

RequirementItem.create(
  category: category,
  type_item: 'lienvideo',
  title: 'Enregistrement vidéo - Air d\'opéra en français',
  description_item: 'Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes. L\'air d\'opéra doit être en français. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.'
)

# Create a RequirementItem for a lied in German
RequirementItem.create(
  category: category,
  type_item: 'lienvideo',
  title: 'Enregistrement vidéo - Lied en allemand',
  description_item: 'Un enregistrement vidéo de bonne qualité, lien YouTube, ne dépassant pas 5 minutes. Le lied doit être en allemand. Les mains du pianiste doivent être visibles en tout temps, sans coupure dans la vidéo.'
)

category = Category.find_by(name: 'Piano under 18')

air1 = Air.create(
  title: "Air 1",
  length_minutes: 5,
  composer: "Composer 1",
  oeuvre: "Oeuvre 1",
  character: "Character 1",
  tonality: "C Major"
)

air2 = Air.create( title: "Air 2", length_minutes: 6, composer: "Composer 2", oeuvre: "Oeuvre 2", character: "Character 2", tonality: "D Major" )
air3 = Air.create( title: "Air 3", length_minutes: 7, composer: "Composer 3", oeuvre: "Oeuvre 3", character: "Character 3", tonality: "E Major" )
air4 = Air.create( title: "Air 4", length_minutes: 4, composer: "Composer 4", oeuvre: "Oeuvre 4", character: "Character 4", tonality: "F Major" )
air5 = Air.create( title: "Air 5", length_minutes: 8, composer: "Composer 5", oeuvre: "Oeuvre 5", character: "Character 5", tonality: "G Major" )
air6 = Air.create( title: "Air 6", length_minutes: 3, composer: "Composer 6", oeuvre: "Oeuvre 6", character: "Character 6", tonality: "A Major" )
air7 = Air.create( title: "Air 7", length_minutes: 9, composer: "Composer 7", oeuvre: "Oeuvre 7", character: "Character 7", tonality: "B Major" )
# ImposedWork
imposed_work_category1 = ImposedWork.create(
  category: category,
  title: 'Oeuvre imposées - Baroque',
  guidelines: 'All pieces must be performed from memory without sheet music.'
)
ImposedWorkAir.create(imposed_work: imposed_work_category1, air: air1)
ImposedWorkAir.create(imposed_work: imposed_work_category1, air: air2)

# ChoiceImposedWork
choice_imposed_work_category1 = ChoiceImposedWork.create(
  category: category,
  title: 'Baroque Selections',
  guidelines: 'Choose any two Baroque era compositions.',
  number_to_select: 2,
  max_length_minutes: 15
)
ChoiceImposedWorkAir.create(choice_imposed_work: choice_imposed_work_category1, air: air3)
ChoiceImposedWorkAir.create(choice_imposed_work: choice_imposed_work_category1, air: air4)

# FreeChoice
free_choice_category1 = FreeChoice.create(
  category: category,
  title: 'Contemporary Choices',
  guidelines: 'Free selection of modern or contemporary pieces.',
  number: 2,
  max_length_minutes: 12
)

# SemiImposedWork
semi_imposed_work_category1 = SemiImposedWork.create(
  category: category,
  guidelines: 'Any work from prominent Romantic composers.',
  number: 2,
  max_length_minutes: 10
)

SemiImposedWorkAir.create(semi_imposed_work: semi_imposed_work_category1, air: air7)
ImposedWorkAir.create(imposed_work: semi_imposed_work_category1, air: air6)
