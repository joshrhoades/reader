class Users::SessionsController < Devise::SessionsController

  def create
    params[:continue_to] ||= "/"
    if real_user
      return render :json => {:success => true, :user => current_user, :continue_to => params[:continue_to]}
    else
      warden.logout(:user)
      params[:user][:remember_me] = params[:user][:remember_me] == "on"
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
      if resource.id != 1 and sign_in(resource_name, resource)
        return render :json => {:success => true, :user => current_user, :continue_to => params[:continue_to]}
      end

      return render :json => {:success => false}

    end
  end

  def failure
    return render :json => {:success => false, :errors => ["Login failed."]}
  end

  #def create
  #  resource = warden.authenticate!(:scope => resource_name, :recall => :failure)
  #  return sign_in_and_redirect(resource_name, resource)
  #end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    puts "sign_in_and_redirect"
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    return render :json => {:success => true, :redirect => stored_location_for(scope) || after_sign_in_path_for(resource)}
  end

  #def failure
  #  return render:json => {:success => false, :errors => ["Login failed."]}
  #end

end