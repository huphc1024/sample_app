class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      login_redirect user
    else
      flash.now[:danger] = t "invalid_user"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_check checked, user
    checked == Settings.checked ? remember(user) : forget(user)
  end

  def login_redirect user
    if user.activated?
      log_in user
      remember_check params[:session][:remember_me], user
      redirect_back_or user
    else
      flash[:danger] = t("account_inactivated") << t("check_email_announce")
      redirect_to root_url
    end
  end
end
