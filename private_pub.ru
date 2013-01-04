require File.expand_path("../config/environment", __FILE__)
require "faye"
Faye::WebSocket.load_adapter('thin')

PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")

app = PrivatePub.faye_app

app.bind(:subscribe) do |client_id, channel|
  puts "client subscribe #{client_id}:#{channel}"
  SubscribeClient.perform_async client_id, channel
end

app.bind(:unsubscribe) do |client_id, channel|
  puts "client unsubscribe #{client_id}:#{channel}"
  UnsubscribeClient.perform_async client_id
end

app.bind(:disconnect) do |client_id|
  puts "client disconnect #{client_id}"
  UnsubscribeClient.perform_async client_id
end

run app
