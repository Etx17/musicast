class InscriptionStepsController < ApplicationController
  include Wicked::Wizard

  steps :program, :item_requirements, :preferences
  before_action :set_inscription

  def edit
    case step
    when :program
    when :item_requirements
      if @inscription.inscription_item_requirements.none?
        @inscription.category.requirement_items.each do |item|
          @inscription.inscription_item_requirements.new(requirement_item: item)
        end
        @inscription.save(validate: false)
      end
    when :preferences
    end
    render_wizard
  end

  def update
    @inscription.assign_attributes(inscription_params)
    case step
    when :program
      if @inscription.valid?(:program)
        @inscription.save
        redirect_to wizard_path(:item_requirements, action: "edit")
      else
        render 'program', status: :unprocessable_entity
      end
    when :item_requirements
      if @inscription.valid?(:item_requirements)
        @inscription.save
        redirect_to wizard_path(:preferences, action: "edit")
      else
        render 'item_requirements', status: :unprocessable_entity
      end
    when :preferences
      if params[:inscription][:payment_proof].present?
        @inscription.payment_proof.purge if @inscription.payment_proof.attached?
        @inscription.payment_proof.attach(params[:inscription][:payment_proof])
      end

      if @inscription.valid?(:preferences)
        if @inscription.is_ready_to_be_reviewed? && (@inscription.status == "draft" || @inscription.status == "request_changes")
          @inscription.status = "in_review"
        end

        @inscription.save
        redirect_to finish_wizard_path
      else
        render 'preferences', status: :unprocessable_entity
      end
    end
  end

  def finish_wizard_path
    inscription_path(@inscription)
  end

  private

  def set_inscription
    @inscription = Inscription.find(params[:inscription_id])
    authorize @inscription if defined?(Pundit)
  end

  def inscription_params
    params.require(:inscription).permit(
      :category_id,
      :status,
      :air,
      :terms_accepted,
      :payment_proof, :remove_payment_proof,
      :candidate_brings_pianist_accompagnateur,
      :candidate_brings_pianist_accompagnateur_email,
      :candidate_brings_pianist_accompagnateur_full_name,
      :time_preference,
      :time_justification,
      inscription_item_requirements_attributes: %i[id submitted_file submitted_content document_id requirement_item_id _destroy],
      choice_imposed_work_airs_attributes: [:id, :choice_imposed_work_id, :air_id],
      semi_imposed_work_airs_attributes: [:id, :semi_imposed_work_id, air_attributes: [:id, :title, :length_minutes, :composer, :oeuvre, :character, :tonality]]
    )
  end
end
