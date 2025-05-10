class CandidatsController < ApplicationController
  before_action :set_candidat, only: %i[show edit update destroy]
  before_action :authorize_candidat, only: [:show, :edit, :update, :destroy]

  # GET /candidats or /candidats.json
  def index
    @candidats = Candidat.all
  end

  # GET /candidats/1 or /candidats/1.json
  def show
    @candidat = Candidat.find(params[:id])
  end

  # GET /candidats/new
  def new
    @candidat = Candidat.new
  end

  # GET /candidats/1/edit
  def edit
  end

  # POST /candidats or /candidats.json
  def create
    @candidat = Candidat.new(candidat_params)

    respond_to do |format|
      if @candidat.save
        format.html { redirect_to candidat_url(@candidat), notice: "Candidat was successfully created." }
        format.json { render :show, status: :created, location: @candidat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @candidat.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # if @candidat.portrait.attached?
    #   processed_image = @candidat.portrait.variant(resize_to_fill: [360, 540]).processed

    #   Tempfile.open do |tempfile|
    #     tempfile.binmode
    #     tempfile.write processed_image.download
    #     tempfile.rewind

    #     @candidat.portrait.attach(io: tempfile, filename: @candidat.portrait.filename, content_type: @candidat.portrait.content_type)
    #   end
    # end

    if @candidat.update(candidat_params)
      redirect_to candidat_url(@candidat), notice: "Candidat was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /candidats/1 or /candidats/1.json
  def destroy
    @candidat.destroy

    respond_to do |format|
      format.html { redirect_to candidats_url, notice: "Candidat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_diploma
    @candidat = Candidat.find(params[:id])
    @candidat.diplomas.attach(params[:candidat][:new_diploma])
    redirect_to edit_candidat_path(@candidat)
  end

  def delete_diploma
    @candidat = Candidat.find(params[:id])
    diploma = @candidat.diplomas.find(params[:diploma_id])
    diploma.purge
    redirect_to candidat_path(@candidat), notice: "Diplôme supprimé"
  end

  def purge_attachment
    @candidat = Candidat.find(params[:id])

    # Find the specific attachment to purge
    attachment_type = params[:attachment_type]

    # Only purge attachments that belong to the candidat model
    if %w[portrait artistic_photo cv_english].include?(attachment_type) && @candidat.send(attachment_type).attached?
      @candidat.send(attachment_type).purge

      respond_to do |format|
        format.html { redirect_to edit_candidat_path(@candidat), notice: "Fichier supprimé avec succès" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_candidat_path(@candidat), alert: "Impossible de supprimer ce fichier" }
        format.json { render json: { error: "Attachment not found" }, status: :not_found }
      end
    end
  end

  def purge_portrait
    @candidat = Candidat.find(params[:id])

    if @candidat.portrait.attached?
      @candidat.portrait.purge

      respond_to do |format|
        format.html { redirect_to edit_candidat_path(@candidat), notice: "Photo de portrait supprimée avec succès" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_candidat_path(@candidat), alert: "Aucun portrait à supprimer" }
        format.json { render json: { error: "No portrait attached" }, status: :not_found }
      end
    end
  end

  def upload_portrait
    @candidat = Candidat.find(params[:id])

    if params[:image].present?
      # Store metadata if available
      metadata = nil
      if params[:image].tempfile.present?
        begin
          require 'mini_magick'
          image = MiniMagick::Image.open(params[:image].tempfile.path)
          metadata = {
            dimensions: {
              width: image.width,
              height: image.height
            },
            size: params[:image].size,
            format: image.type
          }

          # Try to get DPI information
          if image.exif.present? && (image.exif["Resolution"] || image.exif["XResolution"])
            resolution_x = image.exif["XResolution"] || image.exif["Resolution"]
            resolution_y = image.exif["YResolution"] || resolution_x
            metadata[:resolution] = [resolution_x.to_i, resolution_y.to_i]
          else
            # Default to 72 DPI if not specified
            metadata[:resolution] = [72, 72]
          end
        rescue => e
          Rails.logger.error "Error extracting image metadata: #{e.message}"
        end
      end

      # Purge existing portrait if present
      @candidat.portrait.purge if @candidat.portrait.attached?

      # Attach new portrait
      @candidat.portrait.attach(params[:image])
      @candidat.save

      if @candidat.portrait.attached?
        begin
          image_url = url_for(@candidat.portrait)
          render json: {
            success: true,
            message: "Image téléchargée avec succès",
            image_url: image_url,
            metadata: metadata
          }
        rescue => e
          blob = @candidat.portrait.blob
          alt_url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
          render json: {
            success: true,
            message: "Image téléchargée avec succès (URL alternative)",
            image_url: alt_url,
            metadata: metadata
          }
        end
      else
        render json: {
          success: false,
          message: "Impossible d'attacher l'image"
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: "Paramètres manquants"
      }, status: :bad_request
    end
  rescue => e
    Rails.logger.error "Erreur lors du téléchargement de l'image: #{e.message}"
    render json: {
      success: false,
      message: "Une erreur s'est produite: #{e.message}"
    }, status: :internal_server_error
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidat
    @candidat = Candidat.find(params[:id])
  end

  def authorize_candidat
    authorize @candidat
  end

  # Only allow a list of trusted parameters through.
  def candidat_params
    params.require(:candidat).permit(:user_id, :nationality,
    :artistic_photo, :banner_color, :NEW_RECORD,
    :voice_type,
    :first_name, :last_name, :birthdate, :short_bio_en, :medium_bio_en, :long_bio_en, :cv_english, :short_bio, :medium_bio, :long_bio, :repertoire, :portrait, :last_teacher, :iban,
    experiences_attributes: [:id, :title, :english_title, :company, :location, :start_date, :end_date, :description, :english_description, :_destroy, :logo],
    educations_attributes: [:id, :title, :english_title, :organism, :location, :start_date, :end_date, :description, :english_description, :_destroy, :logo],
    diplomas: []
    )
  end
end
