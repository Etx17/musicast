require 'mini_magick'

class ImageMetadataService
  def self.get_image_dpi(image_path)
    begin
      image = MiniMagick::Image.open(image_path)

      # Récupérer la résolution (DPI)
      x_resolution = image.resolution[0]
      y_resolution = image.resolution[1]

      # Log complet des informations
      Rails.logger.info "IMAGE DPI - Using MiniMagick resolution: #{image.resolution.inspect}"

      # Essayer d'extraire les métadonnées DPI en utilisant les commandes ImageMagick directement
      begin
        exif_data = `identify -verbose #{image_path}`
        Rails.logger.info "IMAGE DPI - Raw identify output: #{exif_data[0..100]}"

        # Chercher spécifiquement la résolution
        resolution_match = exif_data.match(/Resolution:.*?(\d+)x(\d+)/)
        if resolution_match
          Rails.logger.info "IMAGE DPI - Found resolution in exif: #{resolution_match[1]}x#{resolution_match[2]}"
        end
      rescue => e
        Rails.logger.error "ERROR getting raw identify data: #{e.message}"
      end

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

  # Estimer le DPI en fonction de la résolution de l'image
  def self.estimate_dpi_from_resolution(width, height)
    # Méthode d'estimation du DPI basée sur la résolution
    # Règles générales:
    # - Images de petite résolution (< 1000px): probablement pour le web, 72-96 DPI
    # - Images de résolution moyenne (1000-2000px): usage mixte, 150-200 DPI
    # - Images haute résolution (> 2000px): probablement pour impression, 300+ DPI
    # - Images très haute résolution (> 4000px): usage professionnel, 600+ DPI

    # Calculer la dimension la plus grande
    max_dimension = [width, height].max

    if max_dimension < 1000
      return 72 # Web standard
    elsif max_dimension < 2000
      return 150 # Qualité moyenne
    elsif max_dimension < 4000
      return 300 # Qualité impression
    else
      return 600 # Qualité professionnelle
    end
  end

  def self.get_complete_metadata(image_path)
    begin
      image = MiniMagick::Image.open(image_path)

      # Essayer d'extraire directement les DPI avec identify
      Rails.logger.info "IMAGE METADATA - Getting metadata for: #{image_path}"

      # Utiliser la commande ImageMagick pour extraire les métadonnées
      exif_output = `identify -verbose #{image_path}`
      Rails.logger.info "IMAGE METADATA - Raw identify partial output: #{exif_output[0..500].gsub(/\n/, ' ')}"

      # Essayer d'extraire la résolution de l'image manuellement
      dpi_x = dpi_y = 72

      # Chercher les valeurs de résolution dans la sortie de identify
      resolution_match = exif_output.match(/Resolution:.*?(\d+)x(\d+)/)
      if resolution_match
        dpi_x = resolution_match[1].to_i
        dpi_y = resolution_match[2].to_i
        Rails.logger.info "IMAGE METADATA - Extracted DPI from exif: #{dpi_x}x#{dpi_y}"
      end

      # Vérifier aussi la résolution de MiniMagick
      mini_magick_res = image.resolution
      Rails.logger.info "IMAGE METADATA - MiniMagick resolution: #{mini_magick_res.inspect}"

      # Si les valeurs de MiniMagick ne sont pas 72x72, les utiliser
      if mini_magick_res[0] != 72 || mini_magick_res[1] != 72
        dpi_x = mini_magick_res[0]
        dpi_y = mini_magick_res[1]
      end

      # Si les DPI sont toujours à 72x72 (valeur par défaut), essayer d'estimer
      # en fonction de la résolution de l'image
      if dpi_x == 72 && dpi_y == 72
        estimated_dpi = estimate_dpi_from_resolution(image.width, image.height)
        Rails.logger.info "IMAGE METADATA - DPI estimé à partir de la résolution: #{estimated_dpi}"
        dpi_x = dpi_y = estimated_dpi
      end

      metadata = {
        dimensions: { width: image.width, height: image.height },
        resolution: [dpi_x, dpi_y],
        format: image.type,
        size: image.size,
        exif: image.exif # Si l'image a des données EXIF
      }

      Rails.logger.info "FINAL METADATA: #{metadata.inspect}"
      return metadata
    rescue => e
      Rails.logger.error "Erreur lors de l'extraction des métadonnées: #{e.message}"
      return nil
    end
  end
end
