class MattersController < ApplicationController
  before_action :check_admin, except: [:index]

  def index
    @matters = Matter.search_matter(params)
  end

  def show
    if params[:id].blank?
      redirect_to(matters_url, alert: '対象が指定されていません')
      return
    end

    @matter = Matter.where(id: params[:id]).first
    @matter_users = MatterUser.where(matter_id: params[:id])
    unless @matter
      redirect_to(matters_url, alert: '対象が見つかりません')
      return
    end
  end

  def new
    @matter = Matter.new
  end

  def create
    @matter = Matter.new(matter_params)
    
    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@matter) unless @matter.valid?
      @matter.save!
    end

    redirect_to(matter_url(@matter), notice: '案件を登録しました')

  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
    if params[:id].blank?
      redirect_to(matters_url, alert: '対象が指定されていません')
      return
    end

    @matter = Matter.where(id: params[:id]).first
    unless @matter
      redirect_to(matters_url, alert: '対象が見つかりません')
      return
    end
  end

  def update
    if params[:id].blank?
      redirect_to(matters_url, alert: '対象が指定されていません')
      return
    end
    @matter =Matter.where(id: params[:id]).first
    unless @matter
      redirect_to(matters_url, alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @matter.update!(matter_params)
    end

    redirect_to(matter_url(@matter), notice: '案件を更新しました')
  rescue ActiveRecord::RecordInvalid => e
    render(:edit)
  end

  def matter_params
    return {} if params[:matter].blank?

    params.require(:matter).permit(:title)
  end

  def destroy
    @matter = Matter.find_by_id(params[:id])

    ActiveRecord::Base.transaction do
      @matter.destroy

      redirect_to(matters_url, notice: '案件を削除しました')
    end
  rescue => e
    redirect_to(matters_url, alert: '案件の削除に失敗しました')
  end

  def add_user
    @matter = Matter.where('id = ?', params[:id]).first
    unless @matter
      redirect_to(matters_path, alert: '対象の案件が見つかりません。')
      return
    end

    @user = User.where('id = ?', params[:user_id]).first
    unless @user
      redirect_to(new_user_matter_url(@matter), alert: '対象の参加者が見つかりません。')
      return
    else
      @matter_user = MatterUser.new(user_id: @user.id, matter_id: @matter.id)
      @matter_user.save!
      redirect_to(matter_path(@matter), notice: '参加者を追加しました。')
    end
  end

  def new_user
    @matter = Matter.where('id = ?', params[:id]).first
    @matter_user = MatterUser.new
    @users = User.search_user(params)
  end

  def remove_user
    @matter = Matter.where('id = ?', params[:id]).first
    @matter_user = MatterUser.find_by_id(params[:matter_user_id])
    unless @matter_user
      redirect_to(matter_path(@matter), alert: '対象の参加者が見つかりません。')
      return
    end

    ActiveRecord::Base.transaction do
      @matter_user.destroy

      redirect_to(matter_path(@matter), notice: '参加者を削除しました。')
    end
  rescue => e
    redirect_to(matter_path(@matter), alert: '参加者の削除に失敗しました。')
  end

  def menu
  end
end
