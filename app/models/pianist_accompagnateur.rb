class PianistAccompagnateur < ApplicationRecord
  has_many :performances
  belongs_to :organism
  VALID_PHONE_REGEX = /\A(\+?\d{1,3}\s?)?(\()?(\d{3})(?(2)\))[-.\s]?\d{3}[-.\s]?\d{4}\z|\A(\+?\d{1,3})?[-.\s]?\d{2}[-.\s]?\d{2}[-.\s]?\d{2}[-.\s]?\d{2}[-.\s]?\d{2}\z/
  validates :full_name, :email, :phone_number, presence: true
  validates :full_name, :email, length: { minimum: 2, maximum: 50}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :phone_number, format: { with: VALID_PHONE_REGEX }
  def is_assigned_to_future_performance?
    performances.where('start_date > ?', Date.today).any?
  end
end

# 123-456-7890
# 123.456.7890
# 123 456 7890
# (123) 456-7890
# +1 123-456-7890
# +1 (967) 266-1668
# +33768757736
# 0182746352
# +33 76 87 57 736
# 01 82 74 63 52
