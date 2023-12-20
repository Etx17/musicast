class ClassicalWorksController < ApplicationController
  def composer_search
    if params[:query].length == 1
      response = Faraday.get("https://api.openopus.org/composer/list/name/#{params[:query]}.json")
      if response.success?
        render json: response.body
      else
        render json: { error: "Failed to fetch composers" }, status: :bad_gateway
      end
    elsif params[:query].length >= 4
      return if params[:query].include?(' ')
      
      response = Faraday.get("https://api.openopus.org/composer/list/search/#{params[:query]}.json")
      if response.success?
        render json: response.body
      else
        render json: { error: "Failed to fetch composers" }, status: :bad_gateway
      end
    end
  end

  def work_search
    composer_id = params[:composer_id] || 'all'
    title_query = params[:query]
    response = Faraday.get("https://api.openopus.org/work/list/composer/#{composer_id}/genre/all/search/#{title_query}.json")
    if response.success?
      render json: response.body
    else
      render json: { error: "Failed to fetch works" }, status: :bad_gateway
    end
  end
end
