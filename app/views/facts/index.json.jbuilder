json.array!(@facts) do |fact|
  json.extract! fact, :id, :fc_range, :fc_fact, :fc_myurl, :fc_idurl
  json.url fact_url(fact, format: :json)
end
