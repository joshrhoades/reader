class PeopleController < ApplicationController
  before_filter :authenticate_user!
  layout :nil

  def index
    @people = current_user.all_following + [current_user]
  end

  def following
    @people = current_user.all_following
  end

  def followers
    @people = current_user.followers
  end

  def may_know
    @people = current_user.possibles
    render :nothing => true if @people.empty?
  end

  def invite
    email = params[:invite_email]

    invited_user = User.where(email: email).first
    if invited_user
      current_user.follow invited_user
      render :json => {:success => "Request sent!"}
    else
      PlusMailer.invite(email, current_user).deliver
      render :json => {:success => "Invite sent!"}
    end
  end

  def items
    where_hash = {user_id: current_user.id, from_id: params[:person_id], params[:filter] => true}
    where_hash.delete("all")
    @items = Item.where(where_hash).limit(Reader::GET_ITEM_BATCH_COUNT).order("entries.published_at DESC")
    render 'items/index', :handlers => [:jbuilder], :formats => [:json]
  end

end
