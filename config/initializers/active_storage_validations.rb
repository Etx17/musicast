Rails.application.config.to_prepare do
  ActiveStorage::Attachment.class_eval do
    def self.max_file_size
      10.megabytes
    end
  end
end
