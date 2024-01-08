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
      @inscriptions = Inscription.all
    end
  end

  def show
  end

  def new
    @inscription = Inscription.new
    category = Category.friendly.find(params[:category_id])
    category.requirement_items.each do |item|
      @inscription.inscription_item_requirements.build(requirement_item: item)
    end
    @inscription.category = category
  end

  def edit
  end

  def create
    @inscription = Inscription.new(inscription_params)
    @inscription.candidat = current_user.candidat
    @inscription.category = Category.friendly.find(inscription_params[:category_id])

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
      format.html { redirect_to inscriptions_url, notice: "Inscription was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_inscription
    @inscription = Inscription.find(params[:id])
  end

  def inscription_params
    params.require(:inscription).permit(:candidat_id, :category_id, :statut,
                                        inscription_item_requirements_attributes: %i[id submitted_content document_id requirement_item_id _destroy])
  end
end
