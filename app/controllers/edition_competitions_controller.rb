class EditionCompetitionsController < ApplicationController
  before_action :set_organism_and_competition, only: %i[remove_document show new edit create update destroy]
  before_action :set_edition_competition, only: %i[remove_document show edit update destroy]
  before_action :require_admin, only: %i[index]

  def index
    @edition_competitions = EditionCompetition.all
  end

  def show
    authorize @edition_competition
    @categories = @edition_competition.categories.order(created_at: :desc)

    if current_user&.organises_edition_competition?(@edition_competition) || current_user&.admin
      render :show
    else
      session[:redirect_url] = organism_competition_edition_competition_url(@organism, @competition, @edition_competition)
      render :candidate_edition_competition
    end
  end

  def new
    @edition_competition = @competition.edition_competitions.build
    @edition_competition.build_address

  end

  def edit;
    authorize @edition_competition
  end

  def create
    @edition_competition = @competition.edition_competitions.build(edition_competition_params)
    if @edition_competition.save
      redirect_to organism_competition_path(@organism, @competition), notice: 'Edition was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @edition_competition
    if @edition_competition.update(edition_competition_params)
      # si jamais on a updaté a "published", alors il faut publier les catégories
      if @edition_competition.status == "published"
        @edition_competition.categories.each do |category|
          category.update(status: "published")
        end
      end
      redirect_to organism_competition_edition_competition_url(@organism, @competition, @edition_competition), notice: "Edition competition was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @edition_competition
    unless @edition_competition.destroy
      @edition_competition.errors.full_messages.each do |message|
        puts message
      end
    end
    redirect_to organism_competition_url(@organism, @edition_competition.competition),
                notice: "Edition competition was successfully destroyed."
  end

  def remove_document
    @edition_competition.rule_document.purge
    redirect_to [@organism, @competition, @edition_competition], notice: 'Document was successfully removed.'
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
      :status,
      :end_of_registration,
      :rule_document,
      :rule_document_english,
      :specific_details_english,
      address_attributes: %i[line1 line2 zipcode city country],
      documents_attributes: %i[file file_url document_type]
    )
  end

  def require_admin
    unless current_user && current_user.admin
      flash[:alert] = "Vous n'êtes pas autorisé à accéder à cette page."
      redirect_to root_path
    end
  end

end
