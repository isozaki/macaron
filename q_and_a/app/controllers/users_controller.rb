class UsersController < ApplicationController
  def index
    @users = User.search_user(params)
  end

  def show
    if params[:id].blank?
      redirect_to(users_url, alert: '対象が指定されていません')
      return
    end

    @user = User.where(id: params[:id]).first
    unless @user
      redirect_to(users_url, alert: '対象が見つかりません')
      return
    end
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
    if params[:id].blank?
      redirect_to(users_url, alert: '対象が指定されていません')
      return
    end

    @user = User.where(id: params[:id]).first
    unless @user
      redirect_to(users_url, alert: '対象が見つかりません')
      return
    end
  end

  def update
    if params[:id].blank?
      redirect_to(users_url, alert: '対象が指定されていません')
      return
    end
    @user =User.where(id: params[:id]).first
    unless @user
      redirect_to(users_url, alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @user.update!(user_params)
    end

    redirect_to(user_url(@user), notice: '利用者を更新しました')
  rescue ActiveRecord::RecordInvalid => e
    render(:edit)
  end

  def destroy
    @user = User.find_by_id(params[:id])

    ActiveRecord::Base.transaction do
      @user.destroy
    end
    redirect_to(users_url, notice: '利用者を削除しました')
  rescue => e
    redirect_to(users_url, alert: '利用者の削除に失敗しました')
  end

  def user_params
    return {} if params[:user].blank?

    params.require(:user).permit(:name, :name_kana, :login, :password, :password_confirmation)
  end
end
