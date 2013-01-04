
class FeedsController < ApplicationController
  def show
    @feed = Feed.find params[:id]
    render :formats => [:json]
  end

  def subscribe
    fu = Feed.find(params[:id]).feed_url

    Subscription.find_or_create_from_url_for_user(fu,current_user)
    render :text => 'ok', :layout => nil
  end
end
