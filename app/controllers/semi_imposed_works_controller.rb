class SemiImposedWorksController < ApplicationController
  before_action :set_semi_imposed_work, only: %i[ show edit update destroy ]

  # GET /semi_imposed_works or /semi_imposed_works.json
  def index
    @semi_imposed_works = SemiImposedWork.all
  end

  # GET /semi_imposed_works/1 or /semi_imposed_works/1.json
  def show
  end

  # GET /semi_imposed_works/new
  def new
    @semi_imposed_work = SemiImposedWork.new
  end

  # GET /semi_imposed_works/1/edit
  def edit
  end

  # POST /semi_imposed_works or /semi_imposed_works.json
  def create
    @semi_imposed_work = SemiImposedWork.new(semi_imposed_work_params)

    respond_to do |format|
      if @semi_imposed_work.save
        format.html { redirect_to semi_imposed_work_url(@semi_imposed_work), notice: "Semi imposed work was successfully created." }
        format.json { render :show, status: :created, location: @semi_imposed_work }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @semi_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semi_imposed_works/1 or /semi_imposed_works/1.json
  def update
    respond_to do |format|
      if @semi_imposed_work.update(semi_imposed_work_params)
        format.html { redirect_to semi_imposed_work_url(@semi_imposed_work), notice: "Semi imposed work was successfully updated." }
        format.json { render :show, status: :ok, location: @semi_imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semi_imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semi_imposed_works/1 or /semi_imposed_works/1.json
  def destroy
    @semi_imposed_work.destroy

    respond_to do |format|
      format.html { redirect_to semi_imposed_works_url, notice: "Semi imposed work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semi_imposed_work
      @semi_imposed_work = SemiImposedWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def semi_imposed_work_params
      params.require(:semi_imposed_work).permit(:programme_requirement_id, :guidelines, :number, :max_length_minutes)
    end
end
