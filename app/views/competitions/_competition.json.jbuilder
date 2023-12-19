json.extract! competition, :id, :organism_id, :nom_concours, :description, :created_at, :updated_at
json.url competition_url(competition, format: :json)
