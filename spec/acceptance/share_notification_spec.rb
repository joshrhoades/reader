require 'acceptance/spec_acceptance_helper'

feature "Shared item notifications", :js => true do

  scenario "A shares with B, B sees notifications" do
    VCR.use_cassette('share notification', :record => :new_episodes) do
      user_a = create_user_a
      user_b = create_user_b
      user_a.follow_and_unblock(user_b)
      user_b.follow_and_unblock(user_a)

      user_a.subscribe_to_url("http://news.ycombinator.com/rss")

      run_jobs


      item = Item.last
      item.shared = true
      item.save!
      run_jobs

      comment = Comment.new
      comment.user = user_a
      comment.body = comment.html = "A Comment"
      comment.item = item
      comment.save!

      run_jobs

      sign_in_as(user_b)

      sleep 1
      page.should have_css("#nav-comments-link.attention")

    end
  end
end
