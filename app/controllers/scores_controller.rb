class ScoresController < ApplicationController
  # skip_before_action :authenticate_user!

  def show
    @category = Category.friendly.find(params[:category_id])
    @tours = @category.tours.includes(performances: [:inscription, scores_attachments: :blob])
  end

  def download_pianist_scores
    # Find resources based on params from the shallower route
    @tour = Tour.find(params[:tour_id])
    # *** Use the correct Pianist model name here ***
    # Example: @pianist = PianistAccompagnateur.find(params[:pianist_id])
    # Example: @pianist = User.find(params[:pianist_id])
    @pianist = PianistAccompagnateur.find(params[:pianist_id])

    performances = @tour.performances .where(pianist_accompagnateur: @pianist) .includes(scores_attachments: :blob)
    scores_to_zip = performances.flat_map { |p| p.scores.attached? ? p.scores.to_a : [] }.compact

    if scores_to_zip.empty?
      redirect_back fallback_location: root_path, alert: "No scores found for performances assigned to #{@pianist.full_name} in this tour."
      return
    end

    zip_filename = "#{@pianist.full_name}_#{@tour.title}_scores.zip"
    temp_file = Tempfile.new(["pianist_#{@pianist.id}_tour_#{@tour.id}_scores", '.zip'])

    begin
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        scores_to_zip.each do |score_attachment|
          blob_data = score_attachment.blob.download
          filename_in_zip = score_attachment.filename.to_s
          zipfile.get_output_stream(filename_in_zip) { |f| f.write(blob_data) }
        end
      end
      zip_data = File.read(temp_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: zip_filename)
    ensure
       temp_file.close
       temp_file.unlink
    end
  end
end
