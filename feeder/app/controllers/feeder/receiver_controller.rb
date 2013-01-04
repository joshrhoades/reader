require_dependency "feeder/application_controller"

module Feeder
  class ReceiverController < ApplicationController
    skip_before_filter :verify_authenticity_token
    def receive
      token = params["token"]
      mode = params["hub.mode"]
      topic = params["hub.topic"]
      verify_token = params["hub.verify_token"]
      challenge = params["hub.challenge"]



      if mode == "subscribe"
        feed = Feed.where(token: token, secret_token: verify_token).first
        feed.push_subscribed = true
        feed.save!
        render :text => challenge
      elsif mode == "unsubscribe"
        feed = Feed.where(token: token, secret_token: verify_token).first
        feed.push_subscribed = false
        feed.save!
        render :text => challenge
      else
        feed = Feed.where(token: token).first
        body = request.body.read
        content_type = request.content_type
        #puts "PuSH received: #{feed.name}"

        body = body.ensure_encoding('UTF-8', :external_encoding  => :sniff, :invalid_characters => :transcode)
        parsed_feed = Feedzirra::Feed.parse(body) do |t|
          ap "parsing content from #{feed.name}: #{t}"
        end
        Feeder::EntryProcessor.process(feed.id, parsed_feed.entries, true)

        render :text => ""
      end
    rescue Feedzirra::NoParserAvailable => e
      puts "no parser available"
      puts feed.name
      puts "\n\n"
      puts body.truncate(2000)
      puts "\n\n"
    end
  end
end
