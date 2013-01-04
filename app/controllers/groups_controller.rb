class GroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @groups = Group.where(:user_id => current_user.id).order("weight DESC")
    @groups.push @groups.shift # move the unlabeled group to the end
  end

  def create
    label = params[:group][:label]
    if label.length == 0
      render :json => {:error => "Please specify a group label"}, :status => :ok and return
    end
    @group = Group.new(params[:group])
    @group.user_id = current_user.id
    if @group.save
      render :json => @group, :status => :created
    else
      render :json => @group.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    return if anonymous_user
    @group = Group.where(:user_id => current_user.id, :id => params[:id]).first
    if @group.destroy
      render :json => @group, :status => :ok
    else
      render :json => @group.errors, :status => :unprocessable_entity
    end
  end

  def update
    return if current_user.anonymous
    @group = Group.find(params[:id])
    @group.label = params[:label]
    @group.weight = params[:weight]
    @group.open = params[:open]
    @group.save
    render "show"
  end

  def items
    group = current_user.groups.where(key: params[:group_id]).first
    @items = []
    group.subscriptions.each do |sub|
      #.where(params[:filter] => true
      q = Item.unscoped.where(user_id: current_user.id, subscription_id: sub.id).limit(Reader::GET_ITEM_BATCH_COUNT)
      unless params[:filter] == "all"
        q = q.where(params[:filter] => true)
      end
      q.all.each do |item|
        @items << item
      end
    end

    @items.sort! {|a,b| b.entry.published_at <=> a.entry.published_at }

    render 'items/index', :handlers => [:jbuilder], :formats => [:json]
  end
end