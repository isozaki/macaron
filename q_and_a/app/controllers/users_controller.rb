class UsersController < ApplicationController
  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@user) unless @user.valid?
      @user.save!
    end

    redirect_to(users_url, notice: '利用者を登録しました')
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
  end

  def login
  end

  def user_params
    return {} if params[:user].blank?

    params.require(:user).permit(:name, :name_kana, :login, :password, :password_confirmation)
  end
end
