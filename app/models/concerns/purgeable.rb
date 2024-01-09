# app/models/concerns/purgeable.rb
module Purgeable
  extend ActiveSupport::Concern

  included do
    before_destroy :purge_all_attachments
  end

  private

  def purge_all_attachments
    self.class.reflect_on_all_associations(:has_one_attached).each do |association|
      attachment = send(association.name)
      attachment.purge_later if attachment.attached?
    end

    self.class.reflect_on_all_associations(:has_many_attached).each do |association|
      attachments = send(association.name)
      attachments.each { |attachment| attachment.purge_later if attachment.attached? }
    end
  end
end
