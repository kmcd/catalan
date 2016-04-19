json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :email
  json.url subscription_url(subscription, format: :json)
end
