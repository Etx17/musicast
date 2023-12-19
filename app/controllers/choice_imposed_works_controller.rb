class ChoiceImposedWorksController < ApplicationController
  before_action :set_choice_imposed_work, only: %i[ show edit update destroy ]

  # GET /choice_imposed_works or /choice_imposed_works.json
  def index
    @choice_imposed_works = ChoiceImposedWork.all
  end

  # GET /choice_imposed_works/1 or /choice_imposed_works/1.json
  def show
  end

  # GET /choice_imposed_works/new
  def new
    @choice_imposed_work = ChoiceImposedWork.new
  end

  # GET /choice_imposed_works/1/edit
  def edit
  end

  # POST /choice_imposed_works or /choice_imposed_works.json
  def create
    @choice_imposed_work = ChoiceImposedWork.new(choice_imposed_work_params)

    respond_to do |format|
      if @choice_imposed_work.save
        format.html { redirect_to choice_imposed_work_url(@choice_imposed_work), notice: "Choice imposed work was successfully created." }
        format.json { render :show, status: :created, location: @choice_imposed_work }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choice_imposed_works/1 or /choice_imposed_works/1.json
  def update
    respond_to do |format|
      if @choice_imposed_work.update(choice_imposed_work_params)
        format.html { redirect_to choice_imposed_work_url(@choice_imposed_work), notice: "Choice imposed work was successfully updated." }
        format.json { render :show, status: :ok, location: @choice_imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choice_imposed_works/1 or /choice_imposed_works/1.json
  def destroy
    @choice_imposed_work.destroy

    respond_to do |format|
      format.html { redirect_to choice_imposed_works_url, notice: "Choice imposed work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_choice_imposed_work
      @choice_imposed_work = ChoiceImposedWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def choice_imposed_work_params
      params.require(:choice_imposed_work).permit(:programme_requirement_id, :title, :guidelines, :number_to_select)
    end
end
