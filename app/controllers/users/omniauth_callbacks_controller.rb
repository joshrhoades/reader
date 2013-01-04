class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def developer
    redirect_to root_path unless Rails.env.development?
    @user = User.find_for_developer_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Developer"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.developer_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def facebook
    auth = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
    # TODO: figure out how to redirect the user to a different location if necessary.
    if @user.persisted?
      fa = FacebookAuthorization.find_or_create_by_user_id @user.id
      fa.token = auth[:credentials][:token]
      # TODO: fix the expire time
      fa.token_expires_at = DateTime.strptime(auth[:credentials][:expires_at].to_s,'%s')
      fa.facebook_id = auth[:uid]
      fa.auth_hash = auth.to_json
      fa.save

      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      warden.logout(:user)
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.developer_data"] = request.env["omniauth.auth"]
      redirect_to '/#login'
    end
  end

  def google
    auth = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    # TODO: figure out how to redirect the user to a different location if necessary.
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.developer_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to '/#login'
  end

end
