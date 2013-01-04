class Api::ShareController < ApplicationController

  def url
    if real_user
      url = params[:url]

      Entry.share(current_user, nil, url)

      respond_to do |format|
        format.html {
          redirect_to "/person/shared/#{current_user.id}"
        }
        format.js {
          head :ok
        }
      end
    else
      redirect_to "/login?continue_to=#{CGI.escape(request.env["REQUEST_URI"])}"
    end
  end

  def content
    if real_user
      title = params[:title]
      url = params[:url]
      content = params[:content]

      Entry.share(current_user, title, content)

      respond_to do |format|
        format.html {
          redirect_to "/person/shared/#{current_user.id}"
        }
        format.js {
          head :ok
        }
      end
    else
      redirect_to "/login?continue_to=#{CGI.escape(request.env["REQUEST_URI"])}"
    end
  end

end