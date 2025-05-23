class AirsController < ApplicationController
  before_action :set_air, only: %i[show edit update destroy]

  # GET /airs or /airs.json
  def index
    @airs = Air.all
  end

  # GET /airs/1 or /airs/1.json
  def show
  end

  # GET /airs/new
  def new
    @air = Air.new
  end

  # GET /airs/1/edit
  def edit
  end

  # POST /airs or /airs.json
  def create
    @air = Air.new(air_params)
    respond_to do |format|
      if @air.save
        format.html { redirect_to air_url(@air), notice: "Air was successfully created." }
        format.json { render :show, status: :created, location: @air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /airs/1 or /airs/1.json
  def update
    respond_to do |format|
      if @air.update(air_params)
        category = nil

        if @air.choice_imposed_work_id.present?
          category = @air.choice_imposed_work.category
        elsif @air.semi_imposed_work_id.present?
          category = @air.semi_imposed_work.category
        elsif @air.imposed_work_id.present?
          category = @air.imposed_work.category
        end

        if category && current_user.organises_category?(category)
          format.html { redirect_to organism_competition_edition_competition_category_path(
            category.edition_competition.organism,
            category.competition,
            category.edition_competition,
            category
          ), notice: "Air was successfully updated." }
        else
          format.html { redirect_to root_path, notice: "Air was successfully updated." }
        end

        format.json { render :show, status: :ok, location: @air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /airs/1 or /airs/1.json
  def destroy
    @air.destroy
    redirect_back fallback_location: root_path, notice: "Air was successfully destroyed."
    # redirect_to params[:redirect_path] || root_path, notice: "Air was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_air
    @air = Air.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def air_params
    params.require(:air).permit(:title, :length_minutes, :composer, :infos, :oeuvre, :character, :tonality, :infos_english, :fach)
  end
end
