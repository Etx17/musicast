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
  name: "Opéra",
  description: "Concours international de chant de Mâcon, édition 2025, du 10 au 16 novembre 2025. Ouvert aux jeunes chanteurs de moins de 35 ans (nés après le 1er janvier 1990). Inscriptions du 17 mars au 10 septembre 2025. Récompenses : 1er prix (5 000€), 2e prix (3 000€), 3e prix (2 000€), prix spécial de la mélodie française (3 000€), prix jeune talent (1 000€), prix du public (500€), prix de l'orchestre (500€), prix des lycéens. Indemnité de 250€ pour les finalistes.",
  min_age: 18,
  max_age: 35,
  discipline: "lyrical_singing",
  price: 60,
  allow_own_pianist_accompagnateur: true,
  payment_after_approval: false
)

imposed_air = Air.create(
  title: "Mélodie contemporaine",
  composer: "Régis Campo",
  oeuvre: "Mélodie contemporaine",
  length_minutes: 4,
  tonality: "C Major",
  infos: "Informations supplémentaires sur cette pièce en français. Contexte historique et conseils d'interprétation.",
  infos_english: "Additional information about this piece in English. Historical context and performance tips."
)
imposed_work= ImposedWork.create(
  category: categ,
  title: "Mélodie contemporaine",
  title_english: "Contemporary melody",
  guidelines: "Mélodie contemporaine imposée pour la demi-finale, composée en 2025 par Régis Campo. Les candidats pourront télécharger les références de la partition directement sur le site internet du concours le 1er juin au plus tard.",
  guidelines_english: "Contemporary imposed melody for the semi-finals, composed in 2025 by Régis Campo. Candidates will be able to download the references of the score directly on the competition website by June 1st at the latest.",
  airs: [ imposed_air ]
  )

SemiImposedWork.create(
  category: categ,
  title: "Mélodie contemporaine",
  title_english: "Contemporary melody",
  guidelines: "Un air d'opéra et une mélodie française. Le tout ne doit pas dépasser 8 minutes. Les œuvres devront être interprétées sans partitions. Aucune transposition n'est possible.",
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
    Air.create!( title: "Ah non credea.... Ah non giunge", composer: "BELLINI", oeuvre: "Sonnambula", character: "Amina", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Air des clochettes", composer: "DELIBES", oeuvre: "Lakmé", character: "Lakmé", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Quel guardo", composer: "DONIZETTI", oeuvre: "Don Pasquale", character: "Norina", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Regnava nel silenzio", composer: "DONIZETTI", oeuvre: "Lucia di Lamermoor", character: "Lucia", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Tornami a vagheggiar", composer: "HAENDEL", oeuvre: "Alcina", character: "Morgana", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Der Hölle Rache", composer: "MOZART", oeuvre: "Die Zauberflöte", character: "La Reine de la Nuit", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Les oiseaux dans la charmille", composer: "OFFENBACH", oeuvre: "Les Contes d'Hoffmann", character: "Olympia", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Una voce poco fa", composer: "ROSSINI", oeuvre: "Il Barbiere di Siviglia", character: "Rosina", fach: :light_soprano_coloratura, length_minutes: 5, tonality: "F Major", infos: "", infos_english: "" ),
    Air.create!( title: "Mein Herr Marquis", composer: "STRAUSS", oeuvre: "Die Fledermauss", character: "Adele", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "A vos yeux, mes amis... Pâle et blonde", composer: "THOMAS", oeuvre: "Hamlet", character: "Ophélie", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Caro nome", composer: "VERDI", oeuvre: "Rigoletto", character: "Gilda", fach: :light_soprano_coloratura, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Qui la voce", composer: "BELLINI", oeuvre: "I Puritani", character: "Elvira", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Je dis que rien ne m'épouvante", composer: "BIZET", oeuvre: "Carmen", character: "Micaëla", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Me voilà seule... Comme autrefois", composer: "BIZET", oeuvre: "Les Pêcheurs de Perles", character: "Leïla", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Je veux vivre dans le rêve", composer: "GOUNOD", oeuvre: "Roméo et Juliette", character: "Juliette", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Quel frisson court dans mes veines", composer: "GOUNOD", oeuvre: "Roméo et Juliette", character: "Juliette", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Allons, il le faut... Adieu notre petite table", composer: "MASSENET", oeuvre: "Manon", character: "Manon", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ach ich fühl's", composer: "MOZART", oeuvre: "Die Zauberflöte", character: "Pamina", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Deh vieni", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Susanna", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Dove sono", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Contessa", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Come scoglio", composer: "MOZART", oeuvre: "Cosi fan tutte", character: "Fiordiligi", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Donde lieta", composer: "PUCCINI", oeuvre: "La Bohème", character: "Mimi", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Quando m'en vo", composer: "PUCCINI", oeuvre: "La Bohème", character: "Musetta", fach: :lyric_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Amour, viens rendre à mon âme", composer: "GLUCK", oeuvre: "Orphée et Eurydice", character: "Orphée", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Elle ne m'entend plus... j'ai perdu mon Eurydice", composer: "GLUCK", oeuvre: "Orphée et Eurydice", character: "Orphée", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Sta nell'iracana", composer: "HAENDEL", oeuvre: "Alcina", character: "Ruggiero", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Empio, diro, tu sei", composer: "HAENDEL", oeuvre: "Giulio Cesare", character: "Cesare", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Svegliatevi nel core", composer: "HAENDEL", oeuvre: "Giulio Cesare", character: "Sesto", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Cara sposa", composer: "HAENDEL", oeuvre: "Rinaldo", character: "Rinaldo", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Nel profondo cieco mondo", composer: "VIVALDI", oeuvre: "Orlando Furioso", character: "Orlando", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Gemo un punto e fremo", composer: "VIVALDI", oeuvre: "L'Olimpiade", character: "Licida", fach: :countertenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Lakmé, ton doux regard se voile", composer: "DELIBES", oeuvre: "Lakmé", character: "Nilakantha", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Vous qui faites l'endormie", composer: "GOUNOD", oeuvre: "Faust", character: "Mephisto", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Sorge infausta", composer: "HAENDEL", oeuvre: "Orlando", character: "Orlando", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "I rage... O ruddier tha the cherry", composer: "HAENDEL", oeuvre: "Acis and Galatea", character: "Polyphemus", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Non piu andrai", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Figaro", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Madamina", composer: "MOZART", oeuvre: "Don Giovanni", character: "Leporello", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "In diesenheil'gen Halle", composer: "MOZART", oeuvre: "Die Zauberflöte", character: "Sarasto", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "La vendetta", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Bartolo", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "La Calumnia", composer: "ROSSINI", oeuvre: "Il Barbiere di Siviglia", character: "Basilio", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Lyubvi", composer: "TCHAIKOVSKY", oeuvre: "Eugène Oneguin", character: "Gremine", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ella giammai m'amo", composer: "VERDI", oeuvre: "Don Carlo", character: "Filippo", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Come dal ciel precipita", composer: "VERDI", oeuvre: "Macbeth", character: "Banco", fach: :bass_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Votre toast", composer: "BIZET", oeuvre: "Carmen", character: "Escamillo", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Cruda, funesta smania", composer: "DONIZETTI", oeuvre: "Lucia di Lamermoor", character: "Enrico", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Vien Leonora", composer: "DONIZETTI", oeuvre: "La Favorita", character: "Alfonso", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Si puo", composer: "LEONCAVALLO", oeuvre: "I Pagliacci", character: "Tonio", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Pieta rispetto amore", composer: "VERDI", oeuvre: "Macbeth", character: "Macbeth", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Il ballen del suo sorriso", composer: "VERDI", oeuvre: "Il Trovatore", character: "di Luna", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Cortigiani", composer: "VERDI", oeuvre: "Rigoletto", character: "Rigoletto", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "O du mein holder Abendstern", composer: "WAGNER", oeuvre: "Tannhaüser", character: "Wolfram", fach: :dramatic_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ah per sempre", composer: "BELLINI", oeuvre: "I Puritani", character: "Riccardo", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "L'orage s'est calmé... O Nadir", composer: "BIZET", oeuvre: "Les Pêcheurs de Perles", character: "Zurga", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Bella siccome un angelo", composer: "DONIZETTI", oeuvre: "Don Pasquale", character: "Malatesta", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Mab, la reine des mensonges", composer: "GOUNOD", oeuvre: "Roméo et Juliette", character: "Mercutio", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Avant de quitter ces lieux", composer: "GOUNOD", oeuvre: "Faust", character: "Valentin", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Donne mie", composer: "MOZART", oeuvre: "Cosi fan tutte", character: "Guglielmo", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Hai gia vinta la causa", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Il Conte", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Largo al factotum", composer: "ROSSINI", oeuvre: "Il Barbiere di Siviglia", character: "Figaro", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Kagda", composer: "TCHAIKOVSKY", oeuvre: "Eugene Oneguin", character: "Oneguin", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Per me giunto... Io morro", composer: "VERDI", oeuvre: "Don Carlo", character: "Posa", fach: :lyric_baritone, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "La Fleur que tu m'avais jetée", composer: "BIZET", oeuvre: "Carmen", character: "Don José", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Come un bel di maggio", composer: "GIORDANO", oeuvre: "Andrea Chenier", character: "Chenier", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Salut, demeure chaste et pure", composer: "GOUNOD", oeuvre: "Faust", character: "Faust", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ah, lève toi, soleil", composer: "GOUNOD", oeuvre: "Roméo et Juliette", character: "Roméo", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Pourquoi me réveiller", composer: "MASSENET", oeuvre: "Werther", character: "Werther", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Dies Bildnis", composer: "MOZART", oeuvre: "Die Zauberflöte", character: "Tamino", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Va pour Kleinzach", composer: "OFFENBACH", oeuvre: "Les Contes d'Hoffmann", character: "Hoffmann", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Che gelida manina", composer: "PUCCINI", oeuvre: "La Bohème", character: "Rodolpho", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "E lucevan le stelle", composer: "PUCCINI", oeuvre: "Tosca", character: "Mario", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Kuda, kuda", composer: "TCHAIKOVSKY", oeuvre: "Eugène Oneguin", character: "Lenski", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Lunge da lei... De miei bollenti spiriti", composer: "VERDI", oeuvre: "La Traviata", character: "Alfredo", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "La donna è mobile", composer: "VERDI", oeuvre: "Rigoletto", character: "Duca", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ah si, ben mio... Di quella pira", composer: "VERDI", oeuvre: "Il Trovatore", character: "Manrico", fach: :lyric_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Je crois entendre encore", composer: "BIZET", oeuvre: "Les Pêcheurs de Perles", character: "Nadir", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Une furtiva lagrima", composer: "DONIZETTI", oeuvre: "L'Elisir d'amore", character: "Nemorino", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ah mes amis... pour mon âme", composer: "DONIZETTI", oeuvre: "La Fille du régiment", character: "Tonio", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Puisqu'on ne peut... vainement ma bien aimée", composer: "LALO", oeuvre: "Le Roi d'Ys", character: "Mylo", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Un'aura amorosa", composer: "MOZART", oeuvre: "Cosi fan tutte", character: "Ferrando", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Il mio tesoro", composer: "MOZART", oeuvre: "Don Giovanni", character: "Don Ottavio", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ecco ridente", composer: "ROSSINI", oeuvre: "Il Barbiere di Siviglia", character: "Almaviva", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Languir per una bella", composer: "ROSSINI", oeuvre: "L'Italiana in Algeri", character: "Lindoro", fach: :light_tenor, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Se Romeo t'uccise un figlio", composer: "BELLINI", oeuvre: "I Capuletti e i Montecchi", character: "Romeo", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Faites-lui mes aveux", composer: "GOUNOD", oeuvre: "Faust", character: "Siebel", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Depuis hier.... Que fais-tu, blanche tourterelle", composer: "GOUNOD", oeuvre: "Roméo et Juliette", character: "Stephano", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Sta nell'ircana", composer: "HAENDEL", oeuvre: "Alcina", character: "Ruggiero", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Enfin, je suis ici...", composer: "MASSENET", oeuvre: "Cendrillon", character: "Cendrillon", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Nobles seigneurs", composer: "MEYERBEER", oeuvre: "Les Huguenots", character: "Urbain", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Non so piu", composer: "MOZART", oeuvre: "Le Nozze di Figaro", character: "Cherubino", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Smanie implacabili", composer: "MOZART", oeuvre: "Cosi fan tutte", character: "Dorabella", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Parto, parto", composer: "MOZART", oeuvre: "La Clemenza di Tito", character: "Sesto", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Oh, la pitoyable aventure", composer: "RAVEL", oeuvre: "L'Heure Espagnole", character: "Conception", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Una voce poco fa", composer: "ROSSINI", oeuvre: "Il Barbiere di Siviglia", character: "Rosina", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: "E Major", infos: "", infos_english: "" ),
    Air.create!( title: "Naqui all'affanno... Non piu mesta", composer: "ROSSINI", oeuvre: "La Cenerentola", character: "Angelina", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Ich lade gern", composer: "STRAUSS", oeuvre: "Die Fledermaus", character: "Orlovsky", fach: :lyric_mezzo_soprano, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "D'amour l'ardente flamme", composer: "BERLIOZ", oeuvre: "La Damnation de Faust", character: "", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "L'amour est un oiseau rebelle", composer: "BIZET", oeuvre: "Carmen", character: "Carmen", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Près des remparts de Séville", composer: "BIZET", oeuvre: "Carmen", character: "Carmen", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "O mio Fernando", composer: "DONIZETTI", oeuvre: "La Favorita", character: "", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Amour, viens rendre à mon âme", composer: "GLUCK", oeuvre: "Orphée et Eurydice", character: "Orphée", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Thy hand, Belinda... When I am laid", composer: "PURCELL", oeuvre: "Dido and Aeneas", character: "Dido", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Cruda sorte", composer: "ROSSINI", oeuvre: "L'Italiana in Algeri", character: "Isabella", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Mon coeur s'ouvre à ta voix", composer: "SAINT-SAENS", oeuvre: "Samson et Dalila", character: "Dalila", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "O don fatale", composer: "VERDI", oeuvre: "Don Carlo", character: "Eboli", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Stride la vampa", composer: "VERDI", oeuvre: "Il Trovatore", character: "Azucena", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" ),
    Air.create!( title: "Weiche, Wotan", composer: "WAGNER", oeuvre: "Das Rheingold", character: "Erda", fach: :contralto, length_minutes: 5, tonality: nil, infos: "", infos_english: "" )
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
  description: "Les quarts de finale, ouverts gratuitement au public, auront lieu le mardi 11 novembre 2025, à l'auditorium du Conservatoire Edgar Varèse. Chaque candidat devra interpréter un air d'opéra de son choix d'une durée maximale de 4 minutes et une mélodie française de son choix d'une durée maximale de 4 minutes",
  description_english: "The quarter-finals, which are free and open to the public, will take place on Tuesday, November 11, 2025, at the Edgar Varèse Conservatory Auditorium. Each candidate must perform an opera aria of their choice (maximum duration: 4 minutes) and a French melody of their choice (maximum duration: 4 minutes)",
  tour_requirement_attributes: {
    description: "Les quarts de finale, ouverts gratuitement au public, auront lieu le mardi 11 novembre 2025, à l'auditorium du Conservatoire Edgar Varèse. Chaque candidat devra interpréter un air d'opéra de son choix d'une durée maximale de 4 minutes et une mélodie française de son choix d'une durée maximale de 4 minutes",
    description_english: "The quarter-finals, which are free and open to the public, will take place on Tuesday, November 11, 2025, at the Edgar Varèse Conservatory Auditorium. Each candidate must perform an opera aria of their choice (maximum duration: 4 minutes) and a French melody of their choice (maximum duration: 4 minutes)",
    min_number_of_works: 2,
    max_number_of_works: 2,
    min_duration_minute: 4,
    max_duration_minute: 9,
    organiser_creates_program: false
  }
)

Tour.create!(
  imposed_air_selection: [imposed_air.id.to_s],
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
    max_number_of_works: 2,
    min_duration_minute: 4.5,
    max_duration_minute: 12,
    organiser_creates_program: true
  }
)

Tour.create!(
  final_performance_submission_deadline: Date.new(2025, 11, 15),
  tour_number: 3,
  category_id: categ.id,
  start_date: Date.new(2025, 11, 16),
  start_time: Time.new(2025, 11, 16, 9, 0),
  end_date: Date.new(2025, 11, 16),
  end_time: Time.new(2025, 11, 16, 18, 0),
  is_online: false,
  requires_orchestra: true,
  requires_pianist_accompanist: false,
  title: "Finale",
  title_english: "Finals",
  description: "Finale avec accompagnement orchestre",
  description_english: "Finals with orchestra accompaniment",
  tour_requirement_attributes: {
    description: "Exigences de la finale: programme imposé avec accompagnement orchestre. Ajoutez votre mélodie si vous souhaitez concourir pour la catégorie supplémentaire et que le jury vous désigne pour.",
    description_english: "Finals requirements: imposed program with orchestra accompaniment",
    min_number_of_works: 2,
    max_number_of_works: 3,
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



# Create prizes for the category
Prize.create!(
  category_id: categ.id,
  title: "1er prix",
  title_english: "1st Prize",
  prize_type: "monetary",
  amount: 5000,
  description: "Le lauréat du 1er prix recevra une récompense de 5 000€",
  description_english: "The 1st Prize winner will receive a cash award of 5,000€"
)

Prize.create!(
  category_id: categ.id,
  title: "2e prix",
  title_english: "2nd Prize",
  amount: 3000,
  prize_type: "monetary",
  description: "Le lauréat du 2e prix recevra une récompense de 3 000€ et participera à une masterclass exclusive.",
  description_english: "The 2nd Prize winner will receive a cash award of 3,000€ and will participate in an exclusive masterclass."
)

Prize.create!(
  category_id: categ.id,
  title: "3e prix",
  title_english: "3rd Prize",
  amount: 2000,
  prize_type: "monetary",
  description: "Le lauréat du 3e prix recevra une récompense de 2 000€",
  description_english: "The 3rd Prize winner will receive a cash award of 2,000€"
)

Prize.create!(
  category_id: categ.id,
  title: "Prix spécial de la mélodie française",
  title_english: "Special French Melody Prize",
  amount: 3000,
  prize_type: "monetary",
  description: "Le lauréat du prix spécial de la mélodie française recevra une récompense de 3 000€",
  description_english: "The Special French Melody Prize winner will receive a cash award of 3,000€"
)

Prize.create!(
  category_id: categ.id,
  title: "Prix jeune talent",
  title_english: "Young Talent Prize",
  amount: 1000,
  prize_type: "monetary",
  description: "Le lauréat du prix jeune talent recevra une récompense de 1 000€",
  description_english: "The Young Talent Prize winner will receive a cash award of 1,000€"
)

Prize.create!(
  category_id: categ.id,
  title: "Prix du public",
  prize_type: "monetary",
  title_english: "Audience Prize",
  amount: 500,
  description: "Le lauréat du prix du public recevra une récompense de 500€",
  description_english: "The Audience Prize winner will receive a cash award of 500€"
)

Prize.create!(
  category_id: categ.id,
  title: "Prix de l'orchestre",
  title_english: "Orchestra Prize",
  prize_type: "monetary",
  amount: 500,
  description: "Le lauréat du prix de l'orchestre recevra une récompense de 500€",
  description_english: "The Orchestra Prize winner will receive a cash award of 500€"
)

Prize.create!(
  category_id: categ.id,
  title: "Prix des lycéens",
  title_english: "High School Prize",
  amount: 0,
  prize_type: "recognition",
  description: "Le lauréat du prix des lycéens recevra ",
  description_english: "The High School Prize is an honorary prize"
)


puts "Fetching existing competition setup for Mâcon..."
begin
  macon_edition = EditionCompetition.find_by!(annee: 2025, competition: Competition.find_by!(nom_concours: "Concours international de chant de Mâcon"))
  macon_category = macon_edition.categories.find_by!(name: "Opéra")
  raise "Mâcon Opéra Category not found" unless macon_category

  semi_imposed_work_definition = macon_category.semi_imposed_works.first # Assuming there is only one, or be more specific
  raise "SemiImposedWork definition for Mâcon category not found" unless semi_imposed_work_definition

  choice_imposed_work_for_final = macon_category.choice_imposed_works.find_by(title: "Liste d'airs d'opéra pour la finale")
  raise "ChoiceImposedWork for Mâcon final (Liste d'airs d'opéra pour la finale) not found" unless choice_imposed_work_for_final
  raise "No airs found in ChoiceImposedWork for Mâcon final" if choice_imposed_work_for_final.airs.empty?


  tour1_quarter_finals = macon_category.tours.find_by!(tour_number: 1)
  tour2_semi_finals = macon_category.tours.find_by!(tour_number: 2)
  tour3_finals = macon_category.tours.find_by!(tour_number: 3)
rescue ActiveRecord::RecordNotFound => e
  puts "Error fetching Mâcon competition setup: #{e.message}. Please ensure the initial part of the seed ran correctly."
  exit
end

puts "All Mâcon setup records found successfully."

# Predefined French melodies as Faker might not be specific enough
FRENCH_MELODIES_POOL = [
  { title: "Après un rêve", composer: "Gabriel Fauré", oeuvre: "Trois mélodies, Op. 7" },
  { title: "Clair de lune", composer: "Claude Debussy", oeuvre: "Suite bergamasque (arr.)" },
  { title: "Beau soir", composer: "Claude Debussy", oeuvre: "Beau soir" },
  { title: "L'invitation au voyage", composer: "Henri Duparc", oeuvre: "Mélodies" },
  { title: "Mandoline", composer: "Gabriel Fauré", oeuvre: "Cinq mélodies 'de Venise', Op. 58" },
  { title: "Chanson triste", composer: "Henri Duparc", oeuvre: "Mélodies" },
  { title: "Phidylé", composer: "Henri Duparc", oeuvre: "Mélodies" },
  { title: "Les berceaux", composer: "Gabriel Fauré", oeuvre: "Trois mélodies, Op. 23" }
]
OPERA_COMPOSERS = ["Verdi", "Mozart", "Puccini", "Bizet", "Rossini", "Donizetti", "Bellini", "Handel", "Gounod", "Massenet"]
OPERA_OEUVRES_SAMPLE = ["La Traviata", "Don Giovanni", "Carmen", "La Bohème", "Le Barbier de Séville", "Lucia di Lammermoor", "Norma", "Rinaldo", "Faust", "Manon"]


puts "Seeding 120 candidates, their inscriptions, semi-imposed airs, and performances for Mâcon Opéra category..."
120.times do |i|
  puts "Creating candidate #{i+1}/120"
  user_email = Faker::Internet.unique.email(domain: "example-candidate.com") # Ensure unique emails
  u = User.create!(
    email: user_email,
    password: 'password',
    password_confirmation: 'password',
    inscription_role: 'candidate',
    accepted_terms: true
  )
  u.candidat.update!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    birthdate: Faker::Date.birthday(min_age: 18, max_age: 34), # Max age 35 means born after Jan 1, 1990 for 2025 competition
    nationality: ["FR", "IT", "DE", "ES", "GB", "US", "CA", "JP", "KR", "CN"].sample,
    short_bio: Faker::Lorem.paragraph(sentence_count: 2),
    medium_bio: Faker::Lorem.paragraph(sentence_count: 5),
    long_bio: Faker::Lorem.paragraph(sentence_count: 10),
    repertoire: Faker::Lorem.paragraph(sentence_count: 5),
    short_bio_en: Faker::Lorem.paragraph(sentence_count: 2),
    medium_bio_en: Faker::Lorem.paragraph(sentence_count: 5),
    long_bio_en: Faker::Lorem.paragraph(sentence_count: 10)
  )

  inscription = Inscription.new(
    category: macon_category,
    status: 'in_review', # Or 'submitted'
    candidat: u.candidat,
    terms_accepted: true
  )
  inscription.save!(validate: false) # Bypassing validations that might require more setup for simplicity

  # InscriptionItemRequirement (YouTube link)
  youtube_requirement = macon_category.requirement_items.find_by(type_item: "youtube_link")
  if youtube_requirement
    InscriptionItemRequirement.create!(
      inscription_id: inscription.id,
      requirement_item: youtube_requirement,
      submitted_content: "https://www.youtube.com/watch?v=#{Faker::Lorem.characters(number: 11)}" # Random YouTube ID like structure
    )
  else
    puts "Warning: YouTube link RequirementItem not found for Mâcon category."
  end

  # Create 2 airs for SemiImposedWork (1 opera, 1 French melody)
  candidate_opera_air = Air.create!(
    title: Faker::Music::Opera.send([:rossini, :verdi, :donizetti, :bellini, :mozart].sample), # Faker opera titles
    composer: OPERA_COMPOSERS.sample,
    oeuvre: OPERA_OEUVRES_SAMPLE.sample,
    length_minutes: rand(3..5),
    tonality: ["C Major", "D Minor", "G Major", "A Minor", "F Major"].sample,
    infos: "Candidate chosen opera aria for semi-imposed work.",
    infos_english: "Candidate chosen opera aria for semi-imposed work (English)."
  )

  french_melody_sample = FRENCH_MELODIES_POOL.sample
  candidate_french_melody = Air.create!(
    title: french_melody_sample[:title],
    composer: french_melody_sample[:composer],
    oeuvre: french_melody_sample[:oeuvre],
    length_minutes: rand(2..4),
    tonality: ["A Minor", "E Major", "Db Major", "F# Minor"].sample,
    infos: "Candidate chosen French melody for semi-imposed work.",
    infos_english: "Candidate chosen French melody for semi-imposed work (English)."
  )

  # Associate these airs with the Inscription via SemiImposedWorkAir
  SemiImposedWorkAir.create!(
    inscription: inscription,
    air: candidate_opera_air,
    semi_imposed_work: semi_imposed_work_definition
  )
  SemiImposedWorkAir.create!(
    inscription: inscription,
    air: candidate_french_melody,
    semi_imposed_work: semi_imposed_work_definition
  )

  # Performance for Tour 1 (Quarts de finale)
  # Uses the 2 airs from SemiImposedWork submission
  Performance.create!(
    inscription: inscription,
    tour: tour1_quarter_finals,
    air_selection: [candidate_opera_air.id, candidate_french_melody.id],
    ordered_air_selection: [candidate_opera_air.id, candidate_french_melody.id] # Order can be same for seeding
  )

  # Performance for Tour 2 (Demi-finales)
  # Uses the global imposed_air + candidate opera_air from semi-imposed
  Performance.create!(
    inscription: inscription,
    tour: tour2_semi_finals,
    air_selection: [imposed_air.id, candidate_opera_air.id],
    ordered_air_selection: [imposed_air.id, candidate_opera_air.id]
  )

  # Candidate selects 2 airs for the Final from ChoiceImposedWork list
  airs_for_final_choices = choice_imposed_work_for_final.airs.sample(2)
  unless airs_for_final_choices.count == 2
    puts "Warning: Could not select 2 distinct airs for final for candidate #{u.candidat.id}. Available: #{choice_imposed_work_for_final.airs.count}"
    # Fallback if not enough airs in choice_imposed_work_for_final (should not happen with current seed)
    airs_for_final_choices = choice_imposed_work_for_final.airs.first(2)
    airs_for_final_choices << choice_imposed_work_for_final.airs.first if airs_for_final_choices.count < 2 && choice_imposed_work_for_final.airs.any? # ensure 2 if possible
  end


  # Performance for Tour 3 (Finale)
  # Uses the 2 airs selected by the candidate from ChoiceImposedWork
  if airs_for_final_choices.count == 2
    Performance.create!(
      inscription: inscription,
      tour: tour3_finals,
      air_selection: airs_for_final_choices.map(&:id),
      ordered_air_selection: airs_for_final_choices.map(&:id) # Order can be same
    )
  else
     puts "Skipping final performance for candidate #{u.candidat.id} due to insufficient airs in choice list."
  end


  # Attach portrait (same logic as before, simplified)
  # Assuming 'john.jpeg' and 'paul.jpg' are in 'app/assets/images/'
  # For robustness, ensure these files exist or handle potential errors
  begin
    portraits_path = Rails.root.join('app', 'assets', 'images')
    available_portraits = [portraits_path.join('john.jpeg'), portraits_path.join('paul.jpg')]
    portrait_file_path = available_portraits.sample

    if File.exist?(portrait_file_path)
      File.open(portrait_file_path, 'rb') do |file|
        u.candidat.portrait.attach(
          io: file,
          filename: File.basename(portrait_file_path),
          content_type: "image/#{File.extname(portrait_file_path).delete('.')}"
        )
      end
    else
      puts "Warning: Portrait file #{portrait_file_path} not found. Skipping portrait attachment for candidate #{u.candidat.id}."
    end
  rescue => e
    puts "Error attaching portrait for candidate #{u.candidat.id}: #{e.message}"
  end
end

puts "Finished seeding 120 candidates for Mâcon."

# Assigner les tessitures (same logic as before)
puts "Assigning voice types to candidates..."
voice_types_for_assignment = Candidat.voice_types.keys - ["non_singer"]
# Ensure we only update those who need it or re-assign 'non_singer', and only for the category we are seeding for.
# Find candidates associated with the macon_category that need voice_type assignment
candidates_in_macon_category_ids = macon_category.inscriptions.pluck(:candidat_id)
candidates_to_assign_voice = Candidat.where(id: candidates_in_macon_category_ids)
                                      .where(voice_type: [nil, 'non_singer'])
                                      .shuffle

voice_cycle = voice_types_for_assignment.cycle

candidates_to_assign_voice.each do |candidate|
  candidate.update!(voice_type: voice_cycle.next)
end
puts "Finished assigning voice types."

puts "Seed for Mâcon competition completed."

# The original candidate seeding loop (20.times do) should be removed or commented out if this new block replaces it.
# Make sure this new block is placed after the initial setup of Macon competition data.
