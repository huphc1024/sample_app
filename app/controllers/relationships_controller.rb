class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_not_following, only: :create
  before_action :load_following, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_not_following
    @user = User.find_by(id: params[:followed_id])
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end

  def load_following
    @relationship = Relationship.find_by id: params[:id]
    return if @relationship
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
