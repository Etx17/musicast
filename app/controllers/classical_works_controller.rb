class ClassicalWorksController < ApplicationController
  def composer_search
    query = params[:query]
    sparql_query = <<-SPARQL
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX ecrm: <http://erlangen-crm.org/current/>

      SELECT DISTINCT ?author ?authorName WHERE {
        ?author a ecrm:E21_Person.
        ?author rdfs:label ?authorName.
        FILTER regex(?authorName, "^#{query}", "i")
      }
      LIMIT 5
    SPARQL

    response = Faraday.post('https://data.doremus.org/sparql') do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = { query: sparql_query }
    end

    if response.success?
      p 'REPONSE SUCCESS'
      # p response.body
      doc = Nokogiri::XML(response.body)
      p doc
      doc.remove_namespaces!
      composer_names = doc.xpath('//binding[@name="authorName"]/literal').map { |node| node.text }
      p composer_names
      render json: composer_names
    else
      render json: { error: "Failed to fetch composers" }, status: :bad_gateway
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
