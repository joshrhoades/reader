require 'acceptance/spec_acceptance_helper'

feature "User A can follow User B", :js => true do

  scenario "A requests to follow B" do
    VCR.use_cassette('follow requests', :record => :new_episodes) do
      user_a = create_user_a
      user_b = create_user_b

      run_jobs

      sign_in_as(user_a)

      visit "/settings"
      click_link "Friends"

      fill_in "E-mail", with: user_b.email

      click_button "Send invite"

      sleep 0.5

      page.should have_content "Request sent"

      run_jobs

      sleep 0.5

      visit("/session/destroy")
      page.driver.reset!
      sign_in_as(user_b)

      page.should have_content "User A would like to follow your shared items"

      click_button "Accept & Follow User A"

      run_jobs

      Follow.count.should == 2
      Follow.all.each do |f|
        f.blocked.should == false
      end

    end
  end

  scenario "A requests to follow C, who is not registered" do
    VCR.use_cassette('follow requests', :record => :new_episodes) do
      user_a = create_user_a
      run_jobs

      sign_in_as(user_a)

      visit "/settings"
      click_link "Friends"

      fill_in "E-mail", with: "c@example.com"

      click_button "Send invite"

      sleep 0.5

      page.should have_content "Invite sent"

      run_jobs

      last_email.body.should include "Come check out 1kpl.us!"

    end
  end
end
