class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_login

  def check_login
    if session[:user_id]
      begin
        @logined_user ||= User.find(session[:user_id])
      rescue
        session[:user_id] = nil
      end
    end

    unless @logined_user
      redirect_to(new_session_path, alert: 'ログイン情報が存在しません')
    end
  end
end
