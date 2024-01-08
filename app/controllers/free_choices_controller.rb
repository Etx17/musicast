class FreeChoicesController < ApplicationController
  before_action :set_free_choice, only: %i[show edit update destroy]

  # GET /free_choices or /free_choices.json
  def index
    @free_choices = FreeChoice.all
  end

  # GET /free_choices/1 or /free_choices/1.json
  def show
  end

  # GET /free_choices/new
  def new
    @free_choice = FreeChoice.new
  end

  # GET /free_choices/1/edit
  def edit
  end

  # POST /free_choices or /free_choices.json
  def create
    @free_choice = FreeChoice.new(free_choice_params)

    respond_to do |format|
      if @free_choice.save
        format.html { redirect_to free_choice_url(@free_choice), notice: "Free choice was successfully created." }
        format.json { render :show, status: :created, location: @free_choice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @free_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /free_choices/1 or /free_choices/1.json
  def update
    respond_to do |format|
      if @free_choice.update(free_choice_params)
        format.html { redirect_to free_choice_url(@free_choice), notice: "Free choice was successfully updated." }
        format.json { render :show, status: :ok, location: @free_choice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @free_choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /free_choices/1 or /free_choices/1.json
  def destroy
    @free_choice.destroy

    respond_to do |format|
      format.html { redirect_to free_choices_url, notice: "Free choice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_free_choice
    @free_choice = FreeChoice.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def free_choice_params
    params.require(:free_choice).permit(:programme_requirement_id, :number, :max_length_minutes)
  end
end
