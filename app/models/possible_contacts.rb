module PossibleContacts

  def possibles
    possible_facebook_contacts
  end

  def possible_facebook_contacts
    FacebookContact.where("left_user_id = ? or right_user_id = ?", id, id).all.collect do |f|
      if f.left_user_id == id
        User.find f.right_user_id
      else
        User.find f.left_user_id
      end
    end
  end

end