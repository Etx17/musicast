class JuriesController < ApplicationController
  before_action :set_jury, only: %i[show edit update destroy]

  def new
    @jury = Jury.new
  end

  # GET /jurys/1/edit
  def edit
  end

  # POST /jurys or /jurys.json
  def create
    @jury = Jury.new(jury_params)
    if @jury.save
      redirect_to jury_url(@jury), notice: "jury was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jurys/1 or /jurys/1.json
  def update
    if @jury.update(jury_params)
      redirect_to jury_url(@jury), notice: "jury was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /jurys/1 or /jurys/1.json
  def destroy
    @jury.destroy
    redirect_to jurys_url, notice: "jury was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_jury
    @jury = jury.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def jury_params
    params.require(:jury).permit(:user_id, :first_name, :last_name, :email, :short_bio)
  end
end
