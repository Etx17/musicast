class ChoiceImposedWorkAirsController < ApplicationController
  before_action :set_choice_imposed_work_air, only: %i[show edit update destroy]

  # GET /choice_imposed_work_airs or /choice_imposed_work_airs.json
  def index
    @choice_imposed_work_airs = ChoiceImposedWorkAir.all
  end

  # GET /choice_imposed_work_airs/1 or /choice_imposed_work_airs/1.json
  def show
  end

  # GET /choice_imposed_work_airs/new
  def new
    @choice_imposed_work_air = ChoiceImposedWorkAir.new
  end

  # GET /choice_imposed_work_airs/1/edit
  def edit
  end

  # POST /choice_imposed_work_airs or /choice_imposed_work_airs.json
  def create
    @choice_imposed_work_air = ChoiceImposedWorkAir.new(choice_imposed_work_air_params)

    respond_to do |format|
      if @choice_imposed_work_air.save
        format.html do
          redirect_to choice_imposed_work_air_url(@choice_imposed_work_air),
                      notice: "Choice imposed work air was successfully created."
        end
        format.json { render :show, status: :created, location: @choice_imposed_work_air }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choice_imposed_work_airs/1 or /choice_imposed_work_airs/1.json
  def update
    respond_to do |format|
      if @choice_imposed_work_air.update(choice_imposed_work_air_params)
        format.html do
          redirect_to choice_imposed_work_air_url(@choice_imposed_work_air),
                      notice: "Choice imposed work air was successfully updated."
        end
        format.json { render :show, status: :ok, location: @choice_imposed_work_air }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work_air.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choice_imposed_work_airs/1 or /choice_imposed_work_airs/1.json
  def destroy
    @choice_imposed_work_air.destroy

    respond_to do |format|
      format.html do
        redirect_to choice_imposed_work_airs_url, notice: "Choice imposed work air was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_choice_imposed_work_air
    @choice_imposed_work_air = ChoiceImposedWorkAir.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def choice_imposed_work_air_params
    params.require(:choice_imposed_work_air).permit(:choice_imposed_work_id, :air_id)
  end
end
