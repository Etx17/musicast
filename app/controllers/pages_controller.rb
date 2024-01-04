require 'music_categories'
class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  def landing
  end


  def home
    @disciplines = MusicCategories::DISCIPLINES
    @edition_competitions = EditionCompetition.where('end_registration_date > ?', Time.now)

    if params[:discipline].present?
      @edition_competitions = @edition_competitions.joins(:categories).where(categories: { discipline: params[:discipline] })
    end

    if params[:country].present?
      @edition_competitions = @edition_competitions.joins(:address).where(addresses: { country: params[:country] })
    end
  end
end
