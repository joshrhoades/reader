require 'feedbag'

class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @subscriptions = Subscription.includes(:feed).includes(:feed_icon).where(:user_id => current_user.id).order("weight DESC")
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def new
    @subscription = Subscription.new
  end

  def items
    sub = Subscription.find params[:subscription_id]
    return unless current_user == sub.user

    @items = Item.unscoped.where(user_id: current_user.id, subscription_id: sub.id)
    unless params[:filter] == "all"
      @items = @items.where(params[:filter] => true)
    end
    @items = @items.limit(Reader::GET_ITEM_BATCH_COUNT).includes(:entry).includes(:comments).includes(:feed).order("created_at DESC")
    ids = params[:ids]
    if ids
      ids = ids.map {|id| id.to_i }.join(',')
      @items = @items.where("id not in (#{ids})")
    end
    @items = @items.all
    @items.sort! {|a,b| b.entry.published_at <=> a.entry.published_at }


    render 'items/index', :handlers => [:jbuilder], :formats => [:json]
  end

  def create
    return if anonymous_user
    feeds = params[:feeds]
    if feeds.present?
      results = []
      feeds.each do |feed|
        subscription = Subscription.find_or_create_from_url_for_user(feed, current_user)
        if subscription.save
          results << subscription
        end
      end
      results = {:subscriptions => results}
      render :json => results, :layout => nil
    else
      feed_url = params[:feed_url]

      u = URI.parse(feed_url)
      if feed_url.include? "reddit.com/r/"
        feed_url = "#{feed_url}/.rss"
        feeds = [{title: feed_url, url: feed_url}]
      else
        feeds = Feedbag.find feed_url
      end

      if feeds.length == 0
        result = {:error => "No RSS or Atom feeds found at #{feed_url}"}
      elsif feeds.length == 1
        subscription = Subscription.find_or_create_from_url_for_user(feeds[0].url, current_user)
        subscription.save
        result = {:subscriptions => [subscription]}
      elsif feeds.length > 1
        result = {:feeds => feeds}
      end
      @result = result
      render :json => @result, :layout => nil
    end
  end

  def destroy
    return if anonymous_user
    sub = Subscription.where(:user_id => current_user.id).find(params[:id])
    return unless current_user.id == sub.user_id
    sub.update_column :deleted, true
    sub.items.all.each do |item|
      item.update_column :unread, false
    end
    render :text => "Sub #{sub.name} deleted"
  end

  def update
    return if current_user.anonymous
    sub = Subscription.find(params[:id])
    return unless current_user.id == sub.user_id
    sub.name = params[:name]
    sub.group_id = params[:group_id]
    sub.weight = params[:weight]
    sub.save
    @subscription = sub
    render "show"
  end
end
