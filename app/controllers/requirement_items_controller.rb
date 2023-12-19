class RequirementItemsController < ApplicationController
  before_action :set_requirement_item, only: %i[ show edit update destroy ]

  # GET /requirement_items or /requirement_items.json
  def index
    @requirement_items = RequirementItem.all
  end

  # GET /requirement_items/1 or /requirement_items/1.json
  def show
  end

  # GET /requirement_items/new
  def new
    @requirement_item = RequirementItem.new
  end

  # GET /requirement_items/1/edit
  def edit
  end

  # POST /requirement_items or /requirement_items.json
  def create
    @requirement_item = RequirementItem.new(requirement_item_params)

    respond_to do |format|
      if @requirement_item.save
        format.html { redirect_to requirement_item_url(@requirement_item), notice: "Requirement item was successfully created." }
        format.json { render :show, status: :created, location: @requirement_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @requirement_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requirement_items/1 or /requirement_items/1.json
  def update
    respond_to do |format|
      if @requirement_item.update(requirement_item_params)
        format.html { redirect_to requirement_item_url(@requirement_item), notice: "Requirement item was successfully updated." }
        format.json { render :show, status: :ok, location: @requirement_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @requirement_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requirement_items/1 or /requirement_items/1.json
  def destroy
    @requirement_item.destroy

    respond_to do |format|
      format.html { redirect_to requirement_items_url, notice: "Requirement item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requirement_item
      @requirement_item = RequirementItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def requirement_item_params
      params.require(:requirement_item).permit(:category_id, :type_item, :description_item, :title)
    end
end
