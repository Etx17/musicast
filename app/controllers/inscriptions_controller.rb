class InscriptionsController < ApplicationController
  before_action :set_inscription, only: %i[show edit update destroy]

  def index
    if params[:category_id].present?
      @category = Category.friendly.find(params[:category_id])
      if @category
        @inscriptions = Inscription.by_category(@category.id)
      else
        flash[:alert] = "Category not found"
      end
    else
      # if user is organisateur show the scope for him, if he is candidat show his scope
      @inscriptions = Inscription.all
    end
    render :candidate_index if current_user.candidat
    render :index if current_user.organisateur
  end

  def show

    render :candidate_show if current_user.candidat
  end

  def new
    # If candidat already created a inscription for the category, redirect to it
    inscription = current_user.candidat.inscriptions.by_category(params[:category_id]).first
    redirect_to inscription_path(inscription) if inscription.present?

    @inscription = Inscription.new
    category = Category.friendly.find(params[:category_id])

    category.requirement_items.each do |item|
      @inscription.inscription_item_requirements.build(requirement_item: item)
    end

    category.choice_imposed_works.each do |choice_imposed_work|
      @inscription.choice_imposed_work_airs.build(choice_imposed_work: choice_imposed_work)
    end

    category.semi_imposed_works.each do |semi_imposed_work|
      semi_imposed_work_air = @inscription.semi_imposed_work_airs.build(semi_imposed_work: semi_imposed_work)
      semi_imposed_work_air.build_air
    end

    @inscription.category = category
  end

  def edit
  end

  def create
    @inscription = Inscription.new(inscription_params)
    @inscription.candidat = current_user.candidat
    # @inscription.category = Category.friendly.find(inscription_params[:category_id])
    raise "NoCandidatError" unless @inscription.candidat
    if @inscription.save
      redirect_to new_inscription_order_path(inscription: @inscription), notice: "Inscription was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @inscription.update(inscription_params)
        format.html { redirect_to inscription_url(@inscription), notice: "Inscription was successfully updated." }
        format.json { render :show, status: :ok, location: @inscription }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @inscription.destroy

    respond_to do |format|
      format.html { redirect_to inscriptions_path, notice: "Inscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_status
    @inscription = Inscription.find(params[:id])
    @inscription.update(status: params[:status])
    redirect_to inscriptions_path(category_id: @inscription.category_id)
  end

  private

  def set_inscription
    @inscription = Inscription.find(params[:id])
  end

  def inscription_params
    params.require(:inscription).permit(
      :candidat_id,
      :category_id,
      :status,
      :air,
      inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
      choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
      semi_imposed_work_airs_attributes: [
        :semi_imposed_work_id,
        air_attributes: [:title, :length_minutes, :composer, :oeuvre, :character, :tonality]
      ]
    )
  end
end
