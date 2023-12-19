class ImposedWorksController < ApplicationController
  before_action :set_imposed_work, only: %i[ show edit update destroy ]

  # GET /imposed_works or /imposed_works.json
  def index
    @imposed_works = ImposedWork.all
  end

  # GET /imposed_works/1 or /imposed_works/1.json
  def show
  end

  # GET /imposed_works/new
  def new
    @imposed_work = ImposedWork.new
  end

  # GET /imposed_works/1/edit
  def edit
  end

  # POST /imposed_works or /imposed_works.json
  def create
    @imposed_work = ImposedWork.new(imposed_work_params)

    respond_to do |format|
      if @imposed_work.save
        format.html { redirect_to imposed_work_url(@imposed_work), notice: "Imposed work was successfully created." }
        format.json { render :show, status: :created, location: @imposed_work }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imposed_works/1 or /imposed_works/1.json
  def update
    respond_to do |format|
      if @imposed_work.update(imposed_work_params)
        format.html { redirect_to imposed_work_url(@imposed_work), notice: "Imposed work was successfully updated." }
        format.json { render :show, status: :ok, location: @imposed_work }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @imposed_work.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imposed_works/1 or /imposed_works/1.json
  def destroy
    @imposed_work.destroy

    respond_to do |format|
      format.html { redirect_to imposed_works_url, notice: "Imposed work was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_imposed_work
      @imposed_work = ImposedWork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def imposed_work_params
      params.require(:imposed_work).permit(:programme_requirement_id, :title, :guidelines)
    end
end
