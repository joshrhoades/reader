class EntriesController < ApplicationController
  before_filter :authenticate_user!

  def show
    @entry = Entry.find(params[:id])
    render :layout => nil
  end

end
