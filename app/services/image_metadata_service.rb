require 'mini_magick'

class ImageMetadataService
  def self.get_image_dpi(image_path)
    begin
      image = MiniMagick::Image.open(image_path)

      # Récupérer la résolution (DPI)
      x_resolution = image.resolution[0]
      y_resolution = image.resolution[1]

      # Si les deux axes ont la même résolution, on peut retourner une seule valeur
      if x_resolution == y_resolution
        return x_resolution
      else
        return { x: x_resolution, y: y_resolution }
      end
    rescue => e
      Rails.logger.error "Erreur lors de l'extraction des métadonnées DPI: #{e.message}"
      return nil
    end
  end

  def self.get_image_dimensions(image_path)
    begin
      image = MiniMagick::Image.open(image_path)
      return { width: image.width, height: image.height }
    rescue => e
      Rails.logger.error "Erreur lors de l'extraction des dimensions: #{e.message}"
      return nil
    end
  end

  def self.get_complete_metadata(image_path)
    begin
      image = MiniMagick::Image.open(image_path)

      metadata = {
        dimensions: { width: image.width, height: image.height },
        resolution: image.resolution,
        format: image.type,
        size: image.size,
        exif: image.exif # Si l'image a des données EXIF
      }

      return metadata
    rescue => e
      Rails.logger.error "Erreur lors de l'extraction des métadonnées: #{e.message}"
      return nil
    end
  end
end
