require 'music_categories'
class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  def landing
  end

  def pricing
  end

  def privacy_policy
  end

  def terms_of_use
  end


  def home
    session[:discipline] = params[:discipline] if params[:discipline].present?
    session[:country] = params[:country][:country] if params[:country].present? && params[:country][:country].present?

    @disciplines = MusicCategories::DISCIPLINES

    @edition_competitions = EditionCompetition.includes(:categories, :address)
                                          .where('end_of_registration > ?', Time.now)
                                          .where(status: 'published')
                                        .order(:end_of_registration)
    if session[:discipline].present?
      @edition_competitions = @edition_competitions.joins(:categories)
                                                    .where(categories: { discipline: session[:discipline].to_i })
    end

    if session[:country].present?
      country = ISO3166::Country[session[:country]].iso_short_name
      @edition_competitions = @edition_competitions.joins(:address)
                                                    .where(addresses: { country: country })
    end
  end
end
