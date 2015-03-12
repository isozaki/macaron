class QuestionsController < ApplicationController
  def index
    @questions = Question.search_question(params)
  end

  def show
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end

    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
      return
    end
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    
    ActiveRecord::Base.transaction do
      fail ActiveRecord::RecordInvalid.new(@question) unless @question.valid?
      @question.save!
    end

    redirect_to(question_url(@question), notice: '質問を登録しました')
  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  def edit
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end

    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
    end
  end

  def update
    if params[:id].blank?
      redirect_to(questions_url, alert: '対象が指定されていません')
      return
    end
    @question = Question.where(id: params[:id]).first
    unless @question
      redirect_to(questions_url, alert: '対象が見つかりません')
      return
    end

    ActiveRecord::Base.transaction do
      @question.update!(question_params)
    end

    redirect_to(question_url(@question), notice: '質問を更新しました')
  rescue ActiveRecord::RecordInvalid => e
     render(:edit)
  end

  def question_params
    return {} if params[:question].blank?

    params.require(:question).permit(
      :title, :question, :charge, :priority, :status, :limit_datetime, :created_user_name,
      :updated_user_name
    )
  end
end
