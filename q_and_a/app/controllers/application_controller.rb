class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_login

  helper_method :logined_user, :check_login, :admin

  def check_login
    if session[:user_id]
      begin
        return @logined_user ||= User.find(session[:user_id])
      rescue
        session[:user_id] = nil
      end
    end

    unless @logined_user
      redirect_to(new_session_path, alert: 'ログイン情報が存在しません')
      return
    end
  end

  def logined_user
    @logined_user
  end

  def admin
    @logined_user.admin
  end

  def check_admin
    if @logined_user.admin
      true
    else
      redirect_to(menus_path, alert: 'アクセス権限がありません。')
    end
  end
end
