class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  def index
    @notes = Note.all
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @jury = Jury.find(params[:jury_id])
    @inscription = Inscription.find(params[:inscription_id])
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @jury = Jury.find(params[:jury_id])
    @inscription =Inscription.find(params[:inscription_id])
    @note = Note.new(note_params)
    @note.jury = @jury
    @note.inscription = @inscription

    if @note.save
      redirect_to jury_jury_inscriptions_path( @jury, category_id: @inscription.category.id), notice: 'Note enregistrée.'
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_url, notice: 'Note was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:jury_id, :inscription_id, :note_value)
    end
end
