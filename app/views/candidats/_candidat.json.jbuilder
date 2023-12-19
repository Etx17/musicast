json.extract! candidat, :id, :user_id, :cv, :bio, :created_at, :updated_at
json.url candidat_url(candidat, format: :json)
