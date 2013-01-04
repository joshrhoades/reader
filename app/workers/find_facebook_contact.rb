class FindFacebookContact
  include Sidekiq::Worker
  sidekiq_options :queue => :contacts
  def perform(id, auth_hash)
    user User.find id
    return if auth_hash.nil?
    Rails.logger.info "look for facebook contacts"
    auth = JSON.parse auth_hash

    fbuser = FbGraph::User.fetch(auth["uid"], :access_token => auth["credentials"]["token"])

    fbuser.friends.each do |friend|
      fb_friend = FacebookAuthorization.find_by_facebook_id friend.identifier
      unless fb_friend.nil?
        names = "#{user.name}; #{fb_friend.user.name}"
        FacebookContact.create(:left_user_id => user.id, :right_user_id => fb_friend.user.id, :names => names)
      end
    end
  end
end
