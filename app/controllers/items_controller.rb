class ItemsController < ApplicationController
  before_filter :authenticate_user!
  def index
    offset = params[:offset]
    offset ||= 0
    if real_user
      @items = Item.for(current_user.id).offset(offset).includes(:subscription).limit(Reader::GET_ITEM_BATCH_COUNT)
    else
      @items = Item.for(current_user.id).where("created_at > ?", Time.now - 7.days)
    end
  end

  def counts
    unread = Item.for(current_user.id).where(unread: true).count
    starred = Item.for(current_user.id).where(starred: true).count
    shared = Item.for(current_user.id).where(shared: true).count
    commented = Item.for(current_user.id).where(commented: true).count
    has_new_comments = Item.for(current_user.id).where(has_new_comments: true).count
    all = Item.for(current_user.id).count

    render :json => {
      unread_count: unread,
      starred_count: starred,
      shared_count: shared,
      commented_count: commented,
      has_new_comments_count: has_new_comments,
      all_count: all
    }
  end

  def all
    @items = current_user.items.limit(Reader::GET_ITEM_BATCH_COUNT).order("entries.published_at DESC")
    exclude_ids
    render 'index', :handlers => [:jbuilder], :formats => [:json]
  end

  def unread
    @items = user_items(:unread)
    exclude_ids
    render 'index', :handlers => [:jbuilder], :formats => [:json]
  end

  def starred
    @items = user_items(:starred)
    exclude_ids
    render 'index', :handlers => [:jbuilder], :formats => [:json]
  end

  def shared
    @items = user_items(:shared)
    exclude_ids
    render 'index', :handlers => [:jbuilder], :formats => [:json]
  end

  def commented
    @items = current_user.items.filter(:commented).limit(Reader::GET_ITEM_BATCH_COUNT).order("comments.created_at DESC")
    exclude_ids
    render 'index', :handlers => [:jbuilder], :formats => [:json]
  end

  def show
    @item = Item.find(params[:id])
  end

  def update
    return if current_user.anonymous
    item = Item.find(params[:id])
    return unless item.user == current_user
    item.unread = params[:unread]
    item.starred = params[:starred]
    item.shared = params[:shared]
    item.has_new_comments = params[:has_new_comments]

    item.save!
    head :ok
  end

  def email_form
    return if current_user.anonymous
    @item = Item.find(params[:id])
    render :layout => nil
  end

  def email
    return if current_user.anonymous
    item = Item.find(params[:id])
    user = current_user
    to = params[:to]
    subject = params[:subject]
    body = params[:body]

    email = {:item => item,:user => user,:to => to, :subject => subject, :body => body}
    ItemMailer.item(email).deliver

    render :layout => nil
  end

  protected
    def exclude_ids
      ids = params[:ids]
      if ids
        ids = ids.map {|id| id.to_i }.join(',')
        @items = @items.where("items.id not in (#{ids})")
      end
    end

    def user_items(filter)
      current_user.items.filter(filter).limit(Reader::GET_ITEM_BATCH_COUNT).order("entries.published_at DESC")
    end

end
