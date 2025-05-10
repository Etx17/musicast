class Air < ApplicationRecord
  # has_many :candidate_program_airs, dependent: :destroy (commented to be able to destroy a list of imposed work air)
  has_many :choice_imposed_work_airs
  has_many :choice_imposed_works, through: :choice_imposed_work_airs

  belongs_to :imposed_work, optional: true
  belongs_to :choice_imposed_work, optional: true
  belongs_to :semi_imposed_work, optional: true

  validates :title, :length_minutes, :composer, :oeuvre, presence: true
  validates :length_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :title, length: { maximum: 70 }
  validates :infos, length: { maximum: 200 }
  validates :composer, length: { maximum: 50 }
  validates :oeuvre, length: { maximum: 50 }

  enum :fach, {
    none: 0,
    light_soprano_coloratura: 1, # Soprano colorature légère
    dramatic_soprano_coloratura: 2, # Soprano colorature dramatique
    light_soprano_lyric: 3, # Soprano lyrique léger
    lyric_soprano: 4, # Soprano lyrique
    spinto_soprano: 5, # Soprano spinto
    dramatic_soprano_lyric: 6, # Soprano lyrique dramatique
    dramatic_soprano: 7, # Soprano dramatique
    falcon_soprano: 8, # Soprano falcon
    soubrette: 9, # Soubrette
    coloratura_mezzo_soprano: 10, # Mezzo-soprano colorature
    lyric_mezzo_soprano: 11, # Mezzo-soprano lyrique
    dramatic_mezzo_soprano: 12, # Mezzo-soprano dramatique
    alto: 13, # Alto
    contralto: 14, # Contralto
    countertenor: 15, # Contre-ténor
    light_tenor: 16, # Ténor léger
    lyric_tenor: 17, # Ténor lyrique
    spinto_tenor: 18, # Ténor spinto
    dramatic_tenor: 19, # Ténor dramatique
    heldentenor: 20, # Heldentenor (ténor héroïque)
    light_baritone: 21, # Baryton léger
    lyric_baritone: 22, # Baryton lyrique
    verdi_baritone: 23, # Baryton Verdi
    dramatic_baritone: 24, # Baryton dramatique
    bass_baritone: 25, # Baryton-basse
    chanting_bass: 26, # Basse chantante
    noble_bass: 27, # Basse noble
    deep_bass: 28 # Basse profonde
  }

  def self.tonalities_selection
    [
      'Aucune / None',
      'C Major / Do majeur / C',
      'C Minor / Do mineur / Cm',
      'C♯/D♭ Major / Do♯/Ré♭ majeur / C#/Db',
      'C♯/D♭ Minor / Do♯/Ré♭ mineur / C#m/Dbm',
      'D Major / Ré majeur / D',
      'D Minor / Ré mineur / Dm',
      'D♯/E♭ Major / Ré♯/Mi♭ majeur / D#/Eb',
      'D♯/E♭ Minor / Ré♯/Mi♭ mineur / D#m/Ebm',
      'E Major / Mi majeur / E',
      'E Minor / Mi mineur / Em',
      'F Major / Fa majeur / F',
      'F Minor / Fa mineur / Fm',
      'F♯/G♭ Major / Fa♯/Sol♭ majeur / F#/Gb',
      'F♯/G♭ Minor / Fa♯/Sol♭ mineur / F#m/Gbm',
      'G Major / Sol majeur / G',
      'G Minor / Sol mineur / Gm',
      'G♯/A♭ Major / Sol♯/La♭ majeur / G#/Ab',
      'G♯/A♭ Minor / Sol♯/La♭ mineur / G#m/Abm',
      'A Major / La majeur / A',
      'A Minor / La mineur / Am',
      'A♯/B♭ Major / La♯/Si♭ majeur / A#/Bb',
      'A♯/B♭ Minor / La♯/Si♭ mineur / A#m/Bbm',
      'B Major / Si majeur / B',
      'B Minor / Si mineur / Bm'
  ]
  end
end
