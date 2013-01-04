module AcceptanceHelpers

  def sign_in_as_user
    visit "/"
    sleep 0.5
    click_link "settings-login-dropdown-link"
    sleep 0.5
    click_link "Log in"
    sleep 0.5
    click_link "Create new account"
    sleep 0.5

    fill_in "Name:", :with => "Herman"
    fill_in "E-mail:", :with => "test@1kpl.us"
    fill_in "Password:", :with => "123456"
    fill_in "Password Confirmation:", :with => "123456"
    find("#register-submit-link-btn").click
    sleep 0.5
  end

  def sign_in_as(user)
    visit "/"
    sleep 0.1
    click_link "settings-login-dropdown-link"
    sleep 0.1
    click_link "Log in"
    sleep 0.1
    fill_in "E-mail:", :with => user.email
    fill_in "Password:", :with => "123123123"
    find("#login-submit-link-btn").click
    sleep 1
    user.reload
  end

  def setup_and_sign_in_user
    user = create_user
    visit "/"
    sleep 0.1
    click_link "settings-login-dropdown-link"
    sleep 0.1
    click_link "Log in"
    sleep 0.1
    fill_in "E-mail:", :with => "gorbles@example.com"
    fill_in "Password:", :with => "123123123"
    find("#login-submit-link-btn").click
    sleep 1
    user.reload
  end

end