class Air < ApplicationRecord

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
    not_specified: 0,
    light_soprano_coloratura: 1,
    dramatic_soprano_coloratura: 2,
    light_soprano_lyric: 3,
    lyric_soprano: 4,
    soprano: 5,
    spinto_soprano: 6,
    dramatic_soprano_lyric: 7,
    dramatic_soprano: 8,
    falcon_soprano: 9,
    soubrette: 10,
    coloratura_mezzo_soprano: 11,
    mezzo_soprano: 12,
    lyric_mezzo_soprano: 13,
    dramatic_mezzo_soprano: 14,
    mezzo: 15,
    alto: 16,
    contralto: 17,
    countertenor: 18,
    light_tenor: 19,
    tenor: 20,
    lyric_tenor: 21,
    spinto_tenor: 22,
    dramatic_tenor: 23,
    heldentenor: 24,
    light_baritone: 25,
    baritone: 26,
    lyric_baritone: 27,
    verdi_baritone: 28,
    dramatic_baritone: 29,
    bass_baritone: 30,
    bass: 31,
    chanting_bass: 32,
    noble_bass: 33,
    deep_bass: 34
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

  def self.fachs_selection
    defined_enums["fach"].keys.map { |key| [I18n.t("fachs.#{key}"), key] }
  end
end
