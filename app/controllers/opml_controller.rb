class OpmlController < ApplicationController

  before_filter :authenticate_user!

  def create
    return if anonymous_user
    file = params[:opml_file]
    if file.nil?
      render :inline => "No OPML File uploaded", :status => 500 and return
    end
    filetext = file.respond_to?(:read) ? file.read : file.to_s
    ImportOpml.perform_async filetext, current_user.id
    redirect_to "/opml_submitted"
  end

  def submitted
    flash[:notice] = "Your feeds are being imported. You will receive an email when import is complete."
    redirect_to "/"
  end

end
