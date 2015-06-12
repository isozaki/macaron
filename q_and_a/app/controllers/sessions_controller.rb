class SessionsController < ApplicationController
  skip_before_action :check_login

  def new
  end

  def create
    user = User.find_by_login(params[:login])
    if user && user.authenticate(params[:pass]) 
      session[:user_id] = user.id
      redirect_to(menus_path, notice: 'ログインしました')
    else
      redirect_to(new_session_path, alert: 'ログインに失敗しました')
    end
  end

  def destroy
    session[:user_id] = nil
    @logind_user = nil
    redirect_to(new_session_path, notice: 'ログアウトしました')
  end
end
