class EditionCompetitionsController < ApplicationController
  before_action :set_organism_and_competition, only: %i[show new edit create update destroy]
  before_action :set_edition_competition, only: %i[show edit update destroy]

  def index
    @edition_competitions = EditionCompetition.all
  end

  def show
    @categories = @edition_competition.categories.order(created_at: :desc)
    if current_user&.organisateur
      render :show
    else
      render :candidate_edition_competition
    end
  end

  def new
    @edition_competition = @competition.edition_competitions.build
    @edition_competition.build_address

  end

  def edit; end

  def create
    @edition_competition = @competition.edition_competitions.build(edition_competition_params)
    if @edition_competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: 'Edition was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @edition_competition.update(edition_competition_params)
      redirect_to organism_competition_url(@organism, @competition), notice: "Edition competition was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @edition_competition.destroy
      @edition_competition.errors.full_messages.each do |message|
        puts message
      end
    end
    redirect_to organism_competition_url(@organism, @edition_competition.competition),
                notice: "Edition competition was successfully destroyed."
  end

  private

  def set_organism_and_competition
    @organism = Organism.friendly.find(params[:organism_id])
    @competition = Competition.friendly.find(params[:competition_id])
  end

  def set_edition_competition
    @edition_competition = EditionCompetition.find(params[:id])
  end

  def edition_competition_params
    params.require(:edition_competition).permit(
      :competition_id,
      :annee,
      :details_specifiques,
      :start_date,
      :end_date,
      :end_of_registration,
      address_attributes: %i[line1 line2 zipcode city country],
      documents_attributes: %i[file file_url document_type]
    )
  end
end
