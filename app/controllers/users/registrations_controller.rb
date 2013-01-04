class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource
    @user = resource
    if resource.save
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
        render "users/registrations/create"
      else
        expire_session_data_after_sign_in!
        render "users/registrations/create"
      end
    else
      render "users/registrations/create"
    end


  end
end