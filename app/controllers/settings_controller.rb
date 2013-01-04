class SettingsController < ApplicationController
  def your_feeds
    @subscriptions = Subscription.where(:user_id => current_user.id)
    render :layout => nil, :template => 'settings/subscription_table'
  end

  def suggested_feeds
    @feeds = Feed.suggested(current_user.id)
    render :layout => nil, :template => 'settings/suggested_feed_table'
  end
end
