class MattersController < ApplicationController
  def index
    @matters = Matter.search_matter(params)
  end

  def show
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
end
