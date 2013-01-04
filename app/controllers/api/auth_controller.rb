class Api::AuthController < ApplicationController

  def authorized
   render :json => {authorized: real_user}
  end

end