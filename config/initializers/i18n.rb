# Configure I18n
require 'i18n/backend/fallbacks'

# Enable fallbacks
I18n::Backend::Simple.include(I18n::Backend::Fallbacks)

# Custom exception handler for missing translations
if Rails.env.development? || Rails.env.test?
  module I18n
    def self.just_raise_that_exception(*args)
      raise args.first
    end
  end

  I18n.exception_handler = :just_raise_that_exception if Rails.env.test?
end

# Add pluralization rules for languages that need them
# Example for French (already included in rails-i18n)
# I18n.backend.store_translations :fr, i18n: {
#   plural: {
#     keys: [:one, :other],
#     rule: lambda { |n| n == 1 ? :one : :other }
#   }
# }
