class ToursController < ApplicationController
  before_action :set_tour, only: %i[ show edit update destroy ]

  # GET /tours or /tours.json
  def index
    @tours = Tour.all
  end

  # GET /tours/1 or /tours/1.json
  def show
  end

  # GET /tours/1/edit
  def edit
  end

  def new
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = @category.tours.build
  end

  def create
    @category = Category.find(params[:category_id])
    @edition_competition = @category.edition_competition
    @competition = @edition_competition.competition
    @tour = @category.tours.build(tour_params)

    if @tour.save
      redirect_to competition_edition_competition_category_tour_path(@competition, @edition_competition, @category, @tour)
    else
      render :new
    end
  end

  # PATCH/PUT /tours/1 or /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to tour_url(@tour), notice: "Tour was successfully updated." }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1 or /tours/1.json
  def destroy
    @tour.destroy

    respond_to do |format|
      format.html { redirect_to tours_url, notice: "Tour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:category_id, :start_date, :start_time, :end_date, :end_time, :is_online, :title, :description)
    end
end
