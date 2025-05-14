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
    @inscription.payment_status = "no_proof_joined_yet" if @inscription.category.payment_after_approval
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

    # Si dans les params y'a un payment_proof, on doit le mettre à jour ( donc purge l'attachment et attacher le nouveau)
    if params[:inscription][:payment_proof].present?
      @inscription.payment_proof.purge
      @inscription.payment_proof.attach(params[:inscription][:payment_proof])
      if @inscription.status == "payment_error_waiting_payment"
        @inscription.status = "new_payment_submitted"
        @inscription.payment_status = "waiting_for_approval"
      else
        @inscription.payment_status = "waiting_for_approval"
      end
    end
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

      # Si l'inscription est completée (mais pas forcément correcte), on la passe en in_review
      if @inscription.is_ready_to_be_reviewed? && (@inscription.status == "draft" || @inscription.status == "request_changes")
        @inscription.status = "in_review"
        @inscription.save
        redirect_to inscription_url(@inscription), notice: t('inscriptions.controller.application_under_review')
      else
        # Si on a modifié des airs d'un choice_imposed_work ou d'un semi_imposed_work, on doit supprimer les performances des tours actuels et suivants.
        @inscription.save
        redirect_to inscription_url(@inscription), notice: t('inscriptions.controller.inscription_updated')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel_performance

    @inscription = Inscription.find(params[:id])
    @inscription.cancelled!
    order_of_destroyed_performance = @inscription.performances.find_by(tour: params["tour_id"]).order
    # # update the order of the performances for the current tour.
    Performance.where(tour: params["tour_id"])
      .where.not(order: nil)
      .where("\"order\" > ?", order_of_destroyed_performance)
      .update_all("\"order\" = \"order\" - 1")

    # Supprimer la performance dont l'inscription a été cancel et les suivante spotentielles

    Inscription.find(params[:id]).performances.destroy_all
    # Et du coup supprimer le planning et planning de répétition (voir tours controller, o delete les pause, set les performance start time à nil et delete les rehearsals)
    @tour = Tour.find(params["tour_id"])
    category = @tour.category
    @tour.pauses&.destroy_all if @tour.pauses.any?
    @tour.performances&.update_all(start_time: nil)
    @tour.candidate_rehearsals&.destroy_all if @tour.candidate_rehearsals.any?

    redirect_to organism_competition_edition_competition_category_tour_path(category.edition_competition.competition.organism, category.edition_competition.competition, category.edition_competition, @tour.category, params["tour_id"]),
      notice: "La performance du candidat a été annulée avec succès. Veuillez regénerer le planning du tour et de ses répétitions "

  end

  def destroy
    authorize @inscription
    category = @inscription.category

    @inscription.destroy

    redirect_to organism_competition_edition_competition_category_tour_path(category.edition_competition.competition.organism, category.edition_competition.competition, category.edition_competition, category, params["tour_id"]), notice: "L'inscription a été supprimée avec succès."

  end

  def update_status
    @inscription = Inscription.find(params[:id])
    @inscription.update(status: params[:status], payment_status: params[:payment_status])

    if @inscription.rejected?
      @inscription.performances.update_all(order: nil)
    end

    if @inscription.accepted?
      # Si jamais on update l'inscription en accepted, on doit find or create la performance du next tour.
      category_first_tour = @inscription.category.tours.order(:tour_number).first
      performance = Performance.find_or_create_by(tour: category_first_tour, inscription: @inscription)
      total_air_selection = performance.air_selection + (category_first_tour.imposed_air_selection || [])

      # Il y avait déja des order sur les perf quand j'ai raise
      performance.update(air_selection: total_air_selection, order: category_first_tour.performances.where.not(order: nil).count + 1)
    end

    redirect_to inscriptions_path(category_id: @inscription.category_id)
  end

  def remove_payment_proof
    @inscription = Inscription.find(params[:id])

    # Vérifier que l'utilisateur actuel est autorisé à modifier cette inscription
    authorize @inscription if defined?(Pundit)

    @inscription.payment_proof.purge

    respond_to do |format|
      format.html { redirect_to @inscription, notice: t('inscriptions.inscription.proof_removed') }
      format.json { head :no_content }
    end
  end

  def request_changes
    @inscription = Inscription.find(params[:id])
    authorize @inscription if defined?(Pundit)

    if @inscription.update(changes_requested: params[:changes_requested], status: :request_changes)
      # Envoyer une notification au candidat (optionnel)
      # InscriptionMailer.changes_requested(@inscription).deliver_later

      redirect_to @inscription, notice: t('inscriptions.controller.changes_requested_success')
    else
      redirect_to @inscription, alert: t('inscriptions.controller.changes_requested_error')
    end
  end

  def start_inscription
    category = Category.find(params[:category_id])

    inscription = current_user.candidat.inscriptions.find_by(category_id: category.id)

    if inscription
      redirect_to edit_inscription_step_path(inscription, :program)
    else
      inscription = current_user.candidat.inscriptions.new(
        category_id: category.id,
        status: 'draft'
      )

      if inscription.save(validate: false)
        redirect_to edit_inscription_step_path(inscription, :program)
      else
        redirect_to root_path, alert: t('inscriptions.notices.could_not_create')
      end
    end
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
        :payment_status,
        :air,
        :terms_accepted,
        :accept_platform_terms,
        :payment_proof, :remove_payment_proof,
        :candidate_brings_pianist_accompagnateur,
        :candidate_brings_pianist_accompagnateur_email,
        :time_justification,
        :candidate_brings_pianist_accompagnateur_full_name,
        inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
        choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
        semi_imposed_work_airs_attributes: [:id, :semi_imposed_work_id, air_attributes: [:id, :title, :length_minutes, :composer, :oeuvre, :character, :tonality]]
      )
    else
      params.require(:inscription).permit(
        :candidat_id,
        :category_id,
        :status,
        :payment_status,
        :terms_accepted,
        :accept_platform_terms,
        :payment_proof, :remove_payment_proof,
        :air,
        :candidate_brings_pianist_accompagnateur,
        :candidate_brings_pianist_accompagnateur_email,
        :candidate_brings_pianist_accompagnateur_full_name,
        :time_justification,
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
