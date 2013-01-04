class Follow < ActiveRecord::Base

  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true



  after_create :block!

  def block!
    unless self.followable.all_following.include? self.follower
      self.update_attribute(:blocked, true)
    end
  end

end
