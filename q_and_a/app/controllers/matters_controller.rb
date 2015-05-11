class MattersController < ApplicationController
  def index
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
  end

  def matter_params
    return {} if params[:matter].blank?

    params.require(:matter).permit(:title)
  end
end
