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

  def build_and_assign_jury
    @user = User.find_by(email: params[:email])
    if @user
      jury = Jury.new(user: @user, email: params[:email], first_name: @user.first_name, last_name: @user.last_name)
      if jury.save
        OrganismJury.create(organism: current_user.organisateur.organism, jury: @user.jury)
        redirect_to organisateur_dashboard_path, notice: "L'utilisateur a été associé à votre organisme en tant que Jury avec succès."
      end
    else
      redirect_to organisateur_dashboard_path, notice: "Aucun utilisateur ne correspond à #{params[:email]}. Invitez-le ci dessus."
      # Handle case when user is not found
    end
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
