class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_reader_user, :get_follower_requests, :do_not_cache, :touch_user
  include ApplicationHelper

  def stats
    redirect_to "/" unless current_user == User.charlie
    @user_count = User.unscoped.count - 1 # anonymous user
    @item_count = Item.unscoped.count
    @sub_count  = Subscription.unscoped.count
    @feed_count = Feed.unscoped.count
    @client_count = Client.unscoped.count
  end

  def index

  end

  def mark_read
    return if current_user.anonymous
    id = params[:id]
    case params[:streamType]
      when "subscription"
        sub = Subscription.find(id)
        Item.unscoped.where(user_id: current_user.id).where(subscription_id: sub.id).update_all(unread: false)
        sub.update_counts
      when "group"
        grp = Group.find(id)
        grp.subscriptions.each do |sub|
          Item.unscoped.where(user_id: current_user.id).where(subscription_id: sub.id).update_all(unread: false)
          sub.update_counts
        end
      when "person"
        person = User.find(id)
        Item.unscoped.where(user_id: current_user.id).where(from_id: person.id).update_all(unread: false)
    end
    head :ok
  end

  def check_reader_user
    unless user_signed_in?
      sign_in(:user, User.where(:anonymous => true).first)
    end
  end

  def get_follower_requests
    unless real_user.nil?
      @follow_requests = current_user.follow_requests
    end
  end

  def do_not_cache
    response.headers["Pragma"] = "no-cache"
    response.headers["Cache-Control"] = "no-cache"
  end

  def touch_user
    if real_user
      current_user.set_weights
      current_user.touch(:last_seen_at)
    end
  end
end
