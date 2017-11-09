json.array!(@reviews) do |review|
  json.extract! review, :id, :rw_date, :rw_file
  json.url review_url(review, format: :json)
end
