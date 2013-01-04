class RevokeComment
  include Sidekiq::Worker
  sidekiq_options :queue => :comments
  def perform(comment_id, user_id)
    puts "revoke comment - #{comment_id}"

    user = User.find user_id
    user.all_following.each do |follower|
      puts 'each follower'
      Client.where(:user_id => follower.id).each do |client|
        Rails.logger.info "App.receiver.removeComment(#{comment_id})"

        begin
          PrivatePub.publish_to client.channel, "App.receiver.removeComment(#{comment_id})"
        rescue Errno::ECONNREFUSED
          client.destroy
        end
      end
    end


  end
end
