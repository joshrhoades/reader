require 'acceptance/spec_acceptance_helper'

feature "Anonymous user visits site", :js => true do
  scenario "default feeds are visible" do
    VCR.use_cassette('anonymous user visits in chrome', :record => :new_episodes) do
      create_anon_feeds
      visit "/"
      page.should have_content "Latest Movie Trailers (27)"
      page.should have_content "Comics"
      page.should have_content "Interesting"
      click_link "Comics"
      page.should have_content "Saw It For You: Homeland, Season 3"
      page.should have_content "chainsawsuit by kris straub"
      page.source.scan("favicon").length.should >= 5
    end
  end
end

feature "Anonymous user visits site in firefox", :driver => :firefox do
  scenario "default feeds are visible" do
    VCR.use_cassette('anonymous user visits in firefox', :record => :new_episodes) do
      create_anon_feeds
      visit "/"
      page.should have_content "Latest Movie Trailers (27)"
      page.should have_content "Comics"
      page.should have_content "Interesting"
      click_link "Comics"
      page.should have_content "Saw It For You: Homeland, Season 3"
      page.should have_content "chainsawsuit by kris straub"
      page.source.scan("favicon").length.should >= 5
    end
  end
end

