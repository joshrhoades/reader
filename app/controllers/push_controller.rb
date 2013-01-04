class PushController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def receiver
    token = params["token"]
    mode = params["hub.mode"]
    topic = params["hub.topic"]
    verify_token = params["hub.verify_token"]
    challenge = params["hub.challenge"]

    feed = Feed.where(token: token, secret_token: verify_token).first

    if mode == "subscribe"
      feed.push_subscribed = true
      feed.save!
      render :text => challenge
    elsif mode == "unsubscribe"
      feed.push_subscribed = false
      feed.save!
      render :text => challenge
    else
      body = request.body.read
      content_type = request.content_type
      render :text => ""
    end
  end
end
