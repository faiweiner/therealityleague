json.array!(@scores) do |score|
  json.extract! score, :id, :round_id, :contestant_id, :event, :points
  json.url score_url(score, format: :json)
end
