class ScoresController < ApplicationController
  # skip_before_action :authenticate_user!

  def show
    @category = Category.friendly.find(params[:category_id])
    @tours = @category.tours.includes(performances: [:inscription, scores_attachments: :blob])
  end
end
