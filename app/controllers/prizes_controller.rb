class PrizesController < ApplicationController
  before_action :set_context, only: %i[ new create edit update destroy ]
  before_action :set_prize  , only: %i[ edit update destroy ]

  # GET /prizes/new
  def new
    @prize = Prize.new
    @prize.category_id = params[:category_id]
  end

  # GET /prizes/1/edit
  def edit
  end

  # POST /prizes or /prizes.json
  def create
    @prize = Prize.new(prize_params)
    @prize.category = @category
    session[:active_tab] = "docs-prizes-jury-tab"
    respond_to do |format|
      if @prize.save
        format.html { redirect_to [@organism, @competition, @edition_competition, @category], notice: "Prize was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prizes/1 or /prizes/1.json
  def update
    respond_to do |format|
      if @prize.update(prize_params)
        format.html { redirect_to [@organism, @competition, @edition_competition, @category], notice: "Prize was successfully updated." }

      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prizes/1 or /prizes/1.json
  def destroy
    @prize.destroy
    session[:active_tab] = "docs-prizes-jury-tab"
    respond_to do |format|
      format.html { redirect_to [@organism, @competition, @edition_competition, @category], notice: "Prize was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @category = Category.friendly.find(params[:category_id])
      @edition_competition = @category.edition_competition
      @competition = @edition_competition.competition
      @organism = @competition.organism
    end

    def set_prize
      @prize = Prize.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def prize_params
      params.require(:prize).permit(
        :title, :title_english,
        :other_reward, :other_reward_english,
        :amount,
        :description, :description_english,
        :category_id
      )
    end
end
