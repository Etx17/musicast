require 'music_categories'
class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  def landing
  end

  def home
    @disciplines = MusicCategories::DISCIPLINES

    @edition_competitions = EditionCompetition.where('end_of_registration > ?', Time.now)

    @edition_competitions = @edition_competitions.joins(:categories).where(categories: { discipline: params[:discipline] }) if params[:discipline].present?

    # return unless params[:country].present?

    # @edition_competitions = @edition_competitions.joins(:address).where(addresses: { country: params[:country] })
  end
end
