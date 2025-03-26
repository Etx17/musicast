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
