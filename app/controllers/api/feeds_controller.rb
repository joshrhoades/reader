require 'feedbag'
class Api::FeedsController < ApplicationController

  def subscribe
    if real_user
      url = params[:url]
      if url.include? "reddit.com/r/"
        url = "#{url}/.rss"
        feeds = [Struct.new(:url, :title, :human_url).new(url, nil, nil)]
      else
        feeds = Feedbag.find url
      end
      if feeds.length == 0
        result = {:error => "No RSS or Atom feeds found at #{url}"}
      elsif feeds.length == 1
        subscription = Subscription.find_or_create_from_url_for_user(feeds[0].url, current_user)
        subscription.save
        result = {:subscriptions => [subscription]}
      elsif feeds.length > 1
        result = {:feeds => feeds}
      end
      @result = result

      respond_to do |format|
        format.html {
          if result[:subscriptions]
            flash[:notice] = "You have subscribed to #{@result[:subscriptions].map(&:name).join(', ')}"
            redirect_to "/"
          end
        }
        format.js {
          render :json => @result, :layout => nil
        }
      end
    else
      redirect_to "/login?d=#{CGI.escape(request.env["REQUEST_URI"])}"
    end
  end

end