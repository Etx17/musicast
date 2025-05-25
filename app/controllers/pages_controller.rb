require 'music_categories'
class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  before_action :authenticate_user!, :require_admin, only: [:admin_dashboard, :admin_create_organism_user]

  def landing
  end

  def pricing
  end

  def privacy_policy
  end

  def terms_of_use
  end

  def platform_terms
  end

  def admin_dashboard
    @organisateurs = Organisateur.all
  end

  def admin_create_organism_user
    @user = User.new(
      email: params[:email],
      password: "password",
      password_confirmation: "password",
      inscription_role: 'organiser',
      accepted_terms: params[:accepted_terms],
    )

    if @user.save
      flash[:notice] = "Organisateur user created successfully"
      redirect_to admin_dashboard_path
    else
      flash[:alert] = "Failed to create user: #{@user.errors.full_messages.join(', ')}"
      redirect_to admin_dashboard_path
    end
  end

  def home
    redirect_to jury_dashboard_path if user_signed_in? && current_user.jury.present? && !current_user.candidat.present?
    # change the params country "France" to it's short country code equivalent if there is a params country. Then make it session
    if params[:country].present?
      country = ISO3166::Country.all.find { |c| c.iso_short_name == params[:country] }
      country_code_params = country&.alpha2
      session[:country] = country_code_params if country_code_params.present?
    end

    session[:discipline] = params[:discipline] if params[:discipline].present?
    # session[:country] = params[:country][:country] if params[:country].present? && params[:country][:country].present?

    @disciplines = MusicCategories::DISCIPLINES
    @edition_competitions = EditionCompetition.published_and_upcoming

    if @edition_competitions.present?
      if session[:discipline].present?
        @edition_competitions = @edition_competitions&.joins(:categories).where(categories: { discipline: session[:discipline].to_i })
      end

      if session[:country].present?
        country = ISO3166::Country[session[:country]].iso_short_name
        @edition_competitions = @edition_competitions&.joins(:address)
                                                      .where(addresses: { country: country })
      end


      @countries_with_upcoming_competitions = EditionCompetition&.includes(:address)
        .where('edition_competitions.start_date > ?', Time.now)
        .pluck('addresses.country')
        .uniq
    end
  end

  private

  def require_admin
    unless current_user.admin
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
