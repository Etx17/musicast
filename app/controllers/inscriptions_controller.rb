class InscriptionsController < ApplicationController
  before_action :set_inscription, only: %i[show edit update destroy]

  def index
    if current_user.candidat
      @inscriptions = Inscription.by_candidat(current_user.candidat.id)
    elsif current_user.organisateur
      if params[:category_id].present?
        @category = Category.friendly.find(params[:category_id])
        @tour = @category.tours.order(:tour_number).first
        @edition_competition = @category.edition_competition
        @competition = @edition_competition.competition
        @organism = @competition.organism

        if @category
          @inscriptions = Inscription.by_category(@category.id)
        else
          flash[:alert] = "Category not found"
        end
      end
    end

    render :index if current_user.organisateur
    render :candidate_index if current_user.candidat
  end

  def jury_index
    @category = Category.friendly.find(params[:category_id])
    @inscriptions = Inscription.by_category(@category.id)
    authorize @inscriptions
  end

  def show
    authorize @inscription
    render :candidate_show if current_user.candidat
  end

  def new
    unless current_user.candidat.has_minimum_informations_for_inscription?
      redirect_to edit_candidat_path(current_user.candidat), notice: t('candidats.edit.minimum_informations_for_inscription')
      return
    end

    @inscription = current_user.candidat.inscriptions.by_category(params[:category_id]).first_or_initialize
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
    @inscription = Inscription.find(params[:id])
    authorize @inscription

    category = @inscription.category
    if category.requirement_items.any? && @inscription.inscription_item_requirements.none?
      category.requirement_items.each do |item|
        @inscription.inscription_item_requirements.build(requirement_item: item)
      end
    end
  end

  def create
    @inscription = Inscription.new(inscription_params)
    @inscription.candidat = current_user.candidat
    air_ids = params[:inscription][:choice_imposed_work_airs_attributes]&.values&.map{|c| c["air_id"]} || []
    if air_ids.uniq.length != air_ids.length
      @inscription.validate
      @inscription.errors.add(:choice_imposed_work_airs_attributes, t("inscriptions.new.same_air_multiple_times"))
      render :new, status: :unprocessable_entity and return
    end
    if @inscription.save
      create_inscription_order(@inscription)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @inscription
    @inscription.assign_attributes(inscription_params)
    if @inscription.valid?
      # TODO: OpenAI validation part if extension enabled ( create table organism_extensions, with enum extensions_type etc)
      if false
        params[:inscription][:inscription_item_requirements_attributes]&.each do |_key, requirement_attributes|
          if requirement_attributes[:submitted_file].present?
            # 1. Check that it is a pdf
            next unless requirement_attributes[:submitted_file].content_type == "application/pdf"
            # 2. Extract the text
            content = requirement_attributes[:submitted_file].tempfile.read
            inscription_requirement_item = InscriptionItemRequirement.find(requirement_attributes[:id])
            requirement_item = RequirementItem.find(requirement_attributes[:requirement_item_id])
            reader = PDF::Reader.new(StringIO.new(content))
            text = reader.pages.map(&:text).join(" ").gsub(/\s+/, ' ')[0..500]
            # 3. send it to open AI and update status
            send_to_openai(text, requirement_item, inscription_requirement_item)
          end
        end
      end

      

      # Si on a modifié des airs d'un choice_imposed_work ou d'un semi_imposed_work, on doit supprimer les performances des tours actuels et suivants.
      @inscription.save
      redirect_to inscription_url(@inscription), notice: "L'inscription a été mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @inscription
    category = @inscription.category
    @inscription.destroy

   redirect_to organism_competition_edition_competition_category_tour_path(category.edition_competition.competition.organism, category.edition_competition.competition, category.edition_competition, category, params["tour_id"]), notice: "L'inscription a été supprimée avec succès."

  end

  def update_status
    @inscription = Inscription.find(params[:id])
    @inscription.update(status: params[:status])

    if @inscription.rejected?
      # Supprimer l'order si jamais il y en avait un
      @inscription.performances.update_all(order: nil)
    end

    if @inscription.accepted?
      # Si jamais on update l'inscription en accepted, on doit find or create la performance du next tour.
      category_first_tour = @inscription.category.tours.order(:tour_number).first
      performance = Performance.find_or_create_by(tour: category_first_tour, inscription: @inscription)
      total_air_selection = performance.air_selection + (category_first_tour.imposed_air_selection || [])
      performance.update(air_selection: total_air_selection, order: category_first_tour.performances.where.not(order: nil).count + 1)
    end

    redirect_to inscriptions_path(category_id: @inscription.category_id)
  end

  private

  def extract_pdf_content
    content = submitted_file.download
    reader = PDF::Reader.new(StringIO.new(content))
    text = reader.pages.map(&:text).join(" ").gsub(/\s+/, ' ')
    text[0..500]
  end

  def send_to_openai(text, requirement_item, inscription_requirement_item)

    api_key = Rails.application.credentials.dig(:open_ai, :test_key)
    client = OpenAI::Client.new
    begin
      response = client.chat(parameters: {
        model: "gpt-4",
        messages: [{
          role: "user",
          content:"Tu ne répond que par '0'( = non), '1' (= oui), ou '2' (= je sais pas).Voici le début d'un document.Répond simplement '1' si le document te semble être un #{requirement_item.type_item} , '0' si ca n'est pas le cas, '2' si tu ne sais pas. Tu ne réponds pas par une phrase, seulement un numéro.Voici l'extrait: " + text
          }]
      })

      if response["choices"][0]["message"]["content"] == "1"
        # Do something if file correspond to what's expected, like maybe update it to checked ai to checked.
        inscription_requirement_item.checked_valid!
      elsif response["choices"][0]["message"]["content"] == "0"
        # Update to not checked
        inscription_requirement_item.checked_invalid!
      elsif response["choices"][0]["message"]["content"] == "2"
        # update to "not sure"
        inscription_requirement_item.not_sure!
      else
        inscription_requirement_item.ai_failed!
      end
    rescue
      inscription_requirement_item.ai_failed!
    end
  end

  def set_inscription
    @inscription = Inscription.find(params[:id])
  end

  def inscription_params
    if action_name == 'create' || action_name == 'update'
      params.require(:inscription).permit(
        :candidat_id,
        :category_id,
        :status,
        :air,
        :terms_accepted,
        :payment_proof,
        :candidate_brings_pianist_accompagnateur,
        inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
        choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
        semi_imposed_work_airs_attributes: [:id, :semi_imposed_work_id, air_attributes: [:id, :title, :length_minutes, :composer, :oeuvre, :character, :tonality]]
      )
    else
      params.require(:inscription).permit(
        :candidat_id,
        :category_id,
        :status,
        :terms_accepted,
        :payment_proof,
        :air,
        :candidate_brings_pianist_accompagnateur,
        inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
        choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
        semi_imposed_work_airs_attributes: [:id, :semi_imposed_work_id, air: [:id, :title, :length_minutes, :composer, :oeuvre, :character, :tonality]]
      )
    end
  end

  def create_inscription_order(inscription)
    inscription_order = InscriptionOrder.create!(
      inscription: inscription,
      amount: inscription.category.price,
      state: 'pending',
      user: current_user
    )
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      customer_email: current_user.email,
      line_items: [
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'Inscription',
            },
            unit_amount: inscription_order.amount_cents,
          },
          quantity: 1
        },
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: 'Commission Musicast',
            },
            unit_amount: 250, # 2.50 EUR in cents
          },
          quantity: 1
        }
      ],
      mode: 'payment',
      # To replace candidat_dashboard_candidatures_path,
      success_url: inscription_order_url(inscription_order),
      cancel_url: inscription_orders_url(inscription_order)
    )

    inscription_order.update(checkout_session_id: session.id)
    redirect_to inscription_url(@inscription), notice: "L'inscription a été mise à jour avec succès."

  end
end
