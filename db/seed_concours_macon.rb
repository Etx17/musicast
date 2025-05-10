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
