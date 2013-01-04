class Users::PasswordsController < Devise::PasswordsController
  skip_before_filter :require_no_authentication
  #def new
  #  build_resource({})
  #end
  layout :nil

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      render :json => {success: true}
    else
      render :json => {errors: resource.errors}
    end
  end

  def edit
    super
    render :layout => nil
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with resource, :layout => nil
    end

  end
end
