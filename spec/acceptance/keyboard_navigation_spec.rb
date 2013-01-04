require 'acceptance/spec_acceptance_helper'

feature "Keyboard navigation", :js => true do
  scenario "keystrokes" do
    VCR.use_cassette('keyboard navigation', :record => :new_episodes) do
      user = setup_and_sign_in_user
      sleep 1

      find("#nav-settings-link").click
      sleep 1
      attach_file("opml_file", "spec/support/fixtures/less-subscriptions.xml")
      sleep 1
      find('#import-btn').click

      Feed.fetchable.each do |f|
        PollFeed.perform_async f.id
      end

      run_jobs
      visit "/"
      sleep 1
      click_link "diy"

      unread_item_count = user.items.filter(:unread).count
      15.times do
        sleep 0.3
        page.driver.browser.execute_script "App.nextItem()"
      end
      sleep 2
      user.items.filter(:unread).count.should == unread_item_count - 15
      page.driver.browser.execute_script "App.showList()"
      visit "/"
      click_link "xkcd"
      unread_item_count = user.items.filter(:unread).count
      sleep 1
      4.times do
        sleep 1
        page.driver.browser.execute_script "App.nextItem()"
      end
      sleep 1
      user.items.filter(:unread).count.should == unread_item_count - 4
    end

  end

  scenario "keystrokes in firefox"
end