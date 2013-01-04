class ShareController < ApplicationController
  before_filter :authenticate_user!

  def create
    if real_user
      title = params[:entry][:title]
      body = params[:entry][:content]
      @item = Entry.share(current_user, title, body)
      head :ok
    else
      head :ok
    end

  end
end