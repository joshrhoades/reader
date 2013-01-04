class Client < ActiveRecord::Base
  belongs_to :user

  #after_create :schedule_client_expiration
  #
  #def schedule_client_expiration
  #  ExpireClient.perform_in(1.minutes, id)
  #end

end