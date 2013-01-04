class UsersController < ApplicationController

  def follow
    target_user = User.find(params[:user_id])
    current_user.follow(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def stop_following
    target_user = User.find(params[:user_id])
    current_user.stop_following(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def block_follower
    target_user = User.find(params[:user_id])
    current_user.block(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def allow
    target_user = User.find(params[:user_id])
    current_user.unblock(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def reciprocate
    target_user = User.find(params[:user_id])
    current_user.unblock(target_user) unless target_user.nil?
    current_user.follow_and_unblock(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def reject
    target_user = User.find(params[:user_id])
    current_user.ignore_requests_from(target_user) unless target_user.nil?
    render :text => "Success", :layout => nil
  end

  def private_pub_sign_on
    render :layout => nil
  end

end