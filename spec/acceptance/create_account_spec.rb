require 'acceptance/spec_acceptance_helper'

feature "User wants to create account", :js => true do

  scenario "User creates account" do
    visit "/"
    sleep 0.5
    click_link "settings-login-dropdown-link"
    sleep 0.5
    click_link "Log in"
    sleep 0.5
    find("#login-close-link-btn").click

    sleep 1
    click_link "settings-login-dropdown-link"
    click_link "Log in"
    sleep 0.5
    click_link "Create new account"
    sleep 0.5

    fill_in "Name:", :with => "Herman"
    fill_in "E-mail:", :with => "test@1kpl.us"
    fill_in "Password:", :with => "123456"
    fill_in "Password Confirmation:", :with => "12345"
    find("#register-submit-link-btn").click
    fill_in "Password Confirmation:", :with => "123456"
    find("#register-submit-link-btn").click
    sleep 0.5
    page.should have_content "Your feeds"
    page.should have_content "Suggested feeds"
  end

  scenario "User forgot password" do
    u = User.new
    u.name = "Steve Polk"
    u.email = "steve@example.com"
    u.password = '123456'
    u.password_confirmation = '123456'
    u.save!

    visit "/"
    click_link "settings-login-dropdown-link"
    sleep 1

    click_link "Log in"
    sleep 1

    click_link "Forgot your password?"
    sleep 1

    fill_in "E-mail:", :with => "test@1kpl.us"
    find("#password-submit-link-btn").click
    sleep 1

    page.should have_content "Email not found"
    fill_in "E-mail:", :with => "steve@example.com"
    find("#password-submit-link-btn").click
    sleep 1

    last_email.body.should include "steve@example.com"
    last_email.body.should include "Change my password"
  end

end