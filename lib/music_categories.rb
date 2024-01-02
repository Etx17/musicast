# lib/music_categories.rb
module MusicCategories
  DISCIPLINES = {
    1 => "Alto",
    2 => "Basson",
    3 => "Chant Lyrique",
    4 => "Chœurs et Chant Choral",
    5 => "Clarinette",
    6 => "Composition et Écriture Musicale",
    7 => "Contrebasse",
    8 => "Cor",
    9 => "Flûte",
    10 => "Guitare",
    11 => "Harpe",
    12 => "Hautbois",
    13 => "Instruments Anciens et Musique Baroque",
    14 => "Musique de Chambre",
    15 => "Orchestration et Direction d'Orchestre",
    16 => "Percussion",
    17 => "Piano",
    18 => "Trombone",
    19 => "Trompette",
    20 => "Tuba",
    21 => "Violon",
    22 => "Violoncelle"
  }.freeze

  def self.disciplines
    DISCIPLINES
  end

  # Add methods to update the array if necessary
end
