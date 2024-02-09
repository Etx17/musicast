class Air < ApplicationRecord
  has_many :candidate_program_airs, dependent: :destroy
  has_many :choice_imposed_work_airs
  has_many :choice_imposed_works, through: :choice_imposed_work_airs

  belongs_to :imposed_work, optional: true
  belongs_to :choice_imposed_work, optional: true
  belongs_to :semi_imposed_work, optional: true

  validates :title, :length_minutes, :composer, :oeuvre, presence: true
  validates :length_minutes, numericality: { only_integer: true, greater_than: 0 }
  # validates :title, length: { maximum: 70 }
  # validates :infos, length: { maximum: 200 }
  # validates :composer, length: { maximum: 50 }
  # validates :oeuvre, length: { maximum: 50 }

  def self.tonalities_selection
    [ 'Aucune',
    'Do majeur', 'Do mineur', 'Do♯ majeur', 'Do♯ mineur', 'Ré♭ majeur', 'Ré♭ mineur',
    'Ré majeur', 'Ré mineur', 'Ré♯ majeur', 'Ré♯ mineur', 'Mi♭ majeur', 'Mi♭ mineur',
    'Mi majeur', 'Mi mineur',
    'Fa majeur', 'Fa mineur', 'Fa♯ majeur', 'Fa♯ mineur', 'Sol♭ majeur', 'Sol♭ mineur',
    'Sol majeur', 'Sol mineur', 'Sol♯ majeur', 'Sol♯ mineur', 'La♭ majeur', 'La♭ mineur',
    'La majeur', 'La mineur', 'La♯ majeur', 'La♯ mineur', 'Si♭ majeur', 'Si♭ mineur',
    'Si majeur', 'Si mineur'
  ]
  end
end
