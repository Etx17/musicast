json.extract! tour, :id, :category_id, :start_date, :start_time, :end_date, :end_time, :is_online, :title,
              :description, :created_at, :updated_at
json.url tour_url(tour, format: :json)
