class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  def landing
  end

  def home
    # list of all edition_competitions where the limit registration date is not passed
  end
end
