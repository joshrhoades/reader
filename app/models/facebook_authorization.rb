class FacebookAuthorization < ActiveRecord::Base
  attr_accessible :auth_hash, :token, :token_expires_at, :user_id
  belongs_to :user

  after_commit :check_for_facebook_friends

  def check_for_facebook_friends
    FindFacebookContact.perform_async self.user.id, auth_hash
  end
end
