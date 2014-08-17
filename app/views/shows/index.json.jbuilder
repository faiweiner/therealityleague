json.array!(@shows) do |show|
  json.extract! show, :id
  json.url show_url(show, format: :json)
end
